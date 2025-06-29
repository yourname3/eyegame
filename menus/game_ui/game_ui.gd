extends Control
class_name GameUI
var gun_panel = preload("res://menus/game_ui/gun_window.tscn")
@onready var vbox_left = $VBoxContainerL
@onready var vbox_right = $VBoxContainerR
var panels_left = []
var left_idx := 0
var right_idx := 0
var panels_right = []

func _ready():
	create_ui()
	
func switch_panel(is_left):
	if is_left:
		panels_left[left_idx].selected = false
		left_idx = (left_idx + 1) % panels_left.size() 
		print("ui_left_idx: ", left_idx)
		panels_left[left_idx].selected = true
	if !is_left:
		panels_right[right_idx].selected = false
		right_idx = (right_idx + 1) % panels_right.size() 
		print("ui_right_idx: ", right_idx)
		panels_right[right_idx].selected = true
	
		
func update_ammo_text():
	for i in panels_left:
		i.set_ammo_text()
	for i in panels_right:
		i.set_ammo_text()
	
func create_ui():
	#Get owned weapons
	var owned_weapon_count = Globals.OWNED_WEAPONS.size()
	for i in range(owned_weapon_count):
		var gp = gun_panel.instantiate()
		panels_left.append(gp)
		gp.weapon_idx = i
		if i == 0:
			gp.selected = true
		vbox_left.add_child(gp)
	for i in range(owned_weapon_count):
		var gp = gun_panel.instantiate()
		panels_right.append(gp)
		gp.weapon_idx = i
		if i == 0:
			gp.selected = true
		gp.layout_direction = 3
		gp.is_right = true
		vbox_right.add_child(gp)
