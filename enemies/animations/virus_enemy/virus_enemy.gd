extends Node2D
class_name VirusEnemy

# Animate ourselves spinning over time
var the_rotation := 0.0

@onready var sprite := %Sprite

var _speed := randf_range(0.25, 0.5) * (randi_range(0, 1) * 2 - 1)
var _phase := 0.0

func _process(delta: float) -> void:
	sprite.global_rotation = the_rotation
	
	_phase = fmod(_phase + 4.0 * delta, TAU)
	scale.x = 1.0 + 0.05 * cos(_phase)
	scale.y = 1.0 + 0.05 * sin(_phase)
	
	the_rotation = fmod(the_rotation + _speed * TAU * delta, TAU)
