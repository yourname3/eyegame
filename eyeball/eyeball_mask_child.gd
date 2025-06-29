@tool
extends Node2D
class_name EyeballMaskChild

# In order to get the masking effect of the eyeball, we must scale it but
# ourselves maintain a scale of 1.0.
#
# So, do that inside this script, and do it as a tool too.

@onready var navigation : NavigationRegion2D = $NavigationRegion
@export var player : Player 

func _ready() -> void:
	Globals.nav_rid = navigation.get_rid()

func _process(delta: float) -> void:
	global_scale = Vector2.ONE
