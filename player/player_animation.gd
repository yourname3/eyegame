extends Node2D
class_name PlayerAnimation

var _last_position := Vector2.ZERO
var position_delta := Vector2.ZERO

func _ready() -> void:
	_last_position = get_parent().position
	
func _physics_process(delta: float) -> void:
	var current_position: Vector2 = get_parent().position
	position_delta = current_position - _last_position
	var parent_vel := (current_position - _last_position) / delta
	
	if parent_vel.length_squared() > 20:
		var target_angle := parent_vel.angle()
		rotation = rotate_toward(rotation, target_angle, TAU * delta * 4)
		
	_last_position = current_position
