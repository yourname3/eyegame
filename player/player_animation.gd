extends Node2D
class_name PlayerAnimation

var _last_position := Vector2.ZERO

func _ready() -> void:
	_last_position = get_parent().position
	
func _physics_process(delta: float) -> void:
	var current_position: Vector2 = get_parent().position
	var parent_vel := (current_position - _last_position) / delta
	
	print(parent_vel)
	
	if parent_vel.length_squared() > 20:
		var target_angle := parent_vel.angle()
		rotation = rotate_toward(rotation, target_angle, TAU * delta * 0.25)
		
	_last_position = current_position
