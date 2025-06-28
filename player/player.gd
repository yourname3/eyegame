extends CharacterBody2D
class_name Player

@export var speed = 400

# TEMPORARY PLAYER CODE FOR ANIMATION
func _process(delta: float) -> void:
	
	# old movement code (doesnt work)
	#var target = get_global_mouse_position()
	#var target_vel = (target - position).normalized() * 300
	#if target.distance_to(position) < 100:
		#target_vel = Vector2.ZERO
	#
	#velocity = velocity.move_toward(target_vel, 500 * delta)
	#move_and_slide()
	pass
	
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	
