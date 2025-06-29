extends Node2D
class_name Game


@export var player : Player

@export var nav_region : NavigationRegion2D




func _ready() -> void:
	Globals.nav_rid = nav_region.get_rid()
	Globals.player = player
	Globals.game_ui_ref = $GameUI/GameUI
	
	#Sounds.play_music(0)
