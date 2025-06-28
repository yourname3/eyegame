extends CharacterBody2D
class_name Player

@export var speed := 700
@export var brake_force := 0.94
@export var acceleration := 15.0


func get_input() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _physics_process(delta: float) -> void:
	var dir := get_input().normalized()
	var target_velocity := dir * speed

	# Apply acceleration if there's input
	if dir != Vector2.ZERO:
		# Accelerate toward target velocity
		velocity = velocity.lerp(target_velocity, acceleration * delta)
		#print("speed = ", velocity.length())
	else:
		# Apply braking force (simulates deceleration)
		velocity *= brake_force
	

	move_and_slide()
