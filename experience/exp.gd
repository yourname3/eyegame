extends CharacterBody2D
var player
var fly : bool = false
var speed = 2000
var accel = 5
var brake_force = .98
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Players")
	if !player:
		print("ERROR: Player not found on EXP orb")
	
func _physics_process(delta: float) -> void:
	if fly:
		var dir = (player.global_position - global_position).normalized()
		var target_velocity = dir * speed

		velocity = velocity.lerp(target_velocity, accel * delta)
		#print("speed = ", velocity.length())
	else:
		# Apply braking force (simulates deceleration)
		velocity *= brake_force
	move_and_slide()
	#if body == player:
		#print("near player")
		#fly = true
