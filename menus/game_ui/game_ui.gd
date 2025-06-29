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
	for i in range(3):
		var gp = gun_panel.instantiate()
		panels_left.append(gp)
		gp.weapon_idx = i
		vbox_left.add_child(gp)
	for i in range(3):
		var gp = gun_panel.instantiate()
		panels_right.append(gp)
		gp.weapon_idx = i
		vbox_right.add_child(gp)
	
func switch_panel(is_left):
	if is_left:
		left_idx = (left_idx + 1) % panels_left.size() 
		print("ui_left_idx: ", left_idx)
	if !is_left:
		right_idx = (right_idx + 1) % panels_right.size() 
		print("ui_right_idx: ", right_idx)
		
func update_ammo_text():
	for i in panels_left:
		i.set_ammo_text()
	for i in panels_right:
		i.set_ammo_text()
	
	
