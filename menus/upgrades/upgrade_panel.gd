extends Control
## A single panel in the upgrade menu. Shows an upgrade and lets us choose it.
class_name UpgradePanel

var current_player: Upgrade = null
var current_enemy: Upgrade = null

signal select_upgrade(panel: UpgradePanel, player: Upgrade, enemy: Upgrade)

func clear() -> void:
	current_player = null
	current_enemy = null
	%SelectButton.hide()

func show_upgrade(player: Upgrade, enemy: Upgrade) -> void:
	current_player = player
	current_enemy = enemy
	
	%PlayerText.text = current_player.description
	%EnemyText.text = current_enemy.description
	%SelectButton.show()
	%AnimationPlayer.play("show")
	
func fade():
	%AnimationPlayer.play("fade")
	
func select_me() -> void:
	if current_player == null || current_enemy == null:
		return
	# This tells the menu to:
	# - Select this upgrade
	# - Clear every panel, so we can't double-select
	select_upgrade.emit(self, current_player, current_enemy)

func _ready() -> void:
	%SelectButton.pressed.connect(select_me)
