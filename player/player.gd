extends CharacterBody2D
class_name Player

# TEMPORARY PLAYER CODE FOR ANIMATION
func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	position = position.move_toward(target, delta * 300)
