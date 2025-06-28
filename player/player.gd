extends CharacterBody2D
class_name Player

# TEMPORARY PLAYER CODE FOR ANIMATION
func _process(delta: float) -> void:
	var target = get_global_mouse_position()
	var target_vel = (target - position).normalized() * 300
	if target.distance_to(position) < 100:
		target_vel = Vector2.ZERO
	
	velocity = velocity.move_toward(target_vel, 500 * delta)
	
	move_and_slide()
