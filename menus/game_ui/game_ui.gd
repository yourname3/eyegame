extends Control
class_name GameUI
var gun_panel = preload("res://menus/game_ui/gun_window.tscn")
@onready var vbox_left = $VBoxContainerL
@onready var vbox_right = $VBoxContainerR
var panels_left = []
var left_idx := 0
var right_idx := 0
var panels_right = []
var health_scale = 15

func _ready():
	create_ui()


func _update_weapon_panels(arr: Array, which_weapon: int) -> void:
	for panel in arr:
		panel.selected = (which_weapon == panel.weapon_idx)

func _process(delta: float) -> void:
	_update_weapon_panels(panels_left, Globals.equipped_left)
	_update_weapon_panels(panels_right, Globals.equipped_right)

#func switch_panel(is_left):
	#if is_left:
		#panels_left[left_idx].selected = false
		#left_idx = (left_idx + 1) % panels_left.size() 
		#print("ui_left_idx: ", left_idx)
		#panels_left[left_idx].selected = true
	#if !is_left:
		#panels_right[right_idx].selected = false
		#right_idx = (right_idx + 1) % panels_right.size() 
		#print("ui_right_idx: ", right_idx)
		#panels_right[right_idx].selected = true
	
func set_player_level(current, needed):
	print("c: ", current, " / n: ", needed)
	$PlayerLevel.scale.x = 1.0*current/needed * 15.0
	print("scalex", $PlayerLevel.scale.x)
	$PlayLevelContainer/Label.text = str("Level: ", Globals.player.level, " ", current, "/", needed )
func set_player_health_ui(hp, max_hp):
	print("Health ", $PlayerHealth.scale.x )
	$PlayerHealth.scale.x = (1.0*hp/max_hp) * 15
	$PlayerHealth/Label.text = str("Player HP: ", hp)
	
func update_ammo_text():
	for i in panels_left:
		if is_instance_valid(i):
			i.set_ammo_text()
	for i in panels_right:
		if is_instance_valid(i):
			i.set_ammo_text()
func update_eye_health(hp, max_hp):
	$PlayerHealth3.scale.x = (1.0*hp/max_hp) * 12.5
	$PlayerHealth3/Label.text = str("Eye HP: ", hp)

func create_ui():
	#Get owned weapons
	var get_children_vl = vbox_left.get_children()
	var get_children_vr = vbox_right.get_children()
	get_children_vl.append_array(get_children_vr)
	for i in get_children_vl:
		i.queue_free()
	panels_left.clear()
	panels_right.clear()
	print("destroying UIWDAYFLWIGAHF")
		
	
	var owned_weapon_idxs = []
	for i in range(Globals.OWNED_WEAPONS.size()):
		if Globals.OWNED_WEAPONS[i]:
			owned_weapon_idxs.append(i)
			print("owned weapon count: ", owned_weapon_idxs)
	for i in (owned_weapon_idxs):
		var gp = gun_panel.instantiate()
		panels_left.append(gp)
		gp.weapon_idx = i
		if i == 0:
			gp.selected = true
		vbox_left.add_child(gp)
		print("adding gp L")
	for i in (owned_weapon_idxs):
		var gp = gun_panel.instantiate()
		panels_right.append(gp)
		gp.weapon_idx = i
		if i == 0:
			gp.selected = true
		gp.layout_direction = 3
		gp.is_right = true
		vbox_right.add_child(gp)
		print("adding gp R")
