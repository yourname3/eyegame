extends Control
## The central controller for the actual upgrading action.
##
## Manages showing upgrades to the player, and applying the selected
## upgrade (through Upgrade.apply())
##
## Contains the entire list of player and enemy ugprades. If you add more
## upgrades, be sure to add them in the array in upgrade_menu.tscn
class_name UpgradeMenu

@onready var panels: Array[UpgradePanel] = [
	%UpgradePanel,
	%UpgradePanel2,
	%UpgradePanel3,
]

@export var player_upgrades: Array[Upgrade] = []
@export var enemy_upgrades: Array[Upgrade] = []

func _choose_not_in(possible: Array[Upgrade], already_chosen: Array[Upgrade]) -> Upgrade:
	var choice = possible.pick_random()
	var fuel = 10000
	while choice in already_chosen:
		choice = possible.pick_random()
		fuel -= 1
		if fuel < 0:
			push_warning("Somehow we weren't able to find 3 different choices")
			break
	
	return choice

# Call this to show new upgrades
# TODO: pause the game? Blink the eye...?
func show_new_upgrades() -> void:
	Globals.push_pause()
	var chosen_player: Array[Upgrade] = []
	var chosen_enemy: Array[Upgrade] = []
	
	for i in range(0, 3):
		chosen_player.append(_choose_not_in(player_upgrades, chosen_player))
		chosen_enemy.append(_choose_not_in(enemy_upgrades, chosen_enemy))
	
	# Show these on the panels.
	for i in range(0, 3):
		panels[i].show_upgrade(chosen_player[i], chosen_enemy[i])
	
	# Animate ourselves in
	%AnimationPlayer.play("show")
	
func select_upgrade(which: UpgradePanel, player: Upgrade, enemy: Upgrade) -> void:
	for panel: UpgradePanel in panels:
		panel.clear()
		if panel == which:
			var tween = panel.create_tween()
			tween.tween_property(panel, "position", panel.position - Vector2(0, 40), 0.3)\
				.set_ease(Tween.EASE_IN_OUT)\
				.set_trans(Tween.TRANS_SINE)
			tween.tween_property(panel, "position", panel.position + Vector2(0, 40), 0.5)\
				.set_ease(Tween.EASE_IN_OUT)\
				.set_trans(Tween.TRANS_SINE)
			tween.parallel().tween_callback(panel.fade)
		else:
			panel.fade()
	
	%AnimationPlayer.play("hide")
	player.apply()
	enemy.apply()
	SignalBus.level_up_finished.emit()
	Globals.pop_pause()
	
func _ready() -> void:
	for panel in panels:
		panel.select_upgrade.connect(select_upgrade)
	# Be sure to start out hidden
	hide()
	
	SignalBus.level_up.connect(show_new_upgrades)
	
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("debug_upgrade"):
	#	show_new_upgrades()
