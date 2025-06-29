extends BasicBullet
class_name HomingBullet




@export var agent : NavigationAgent2D 
var target : Player 

func _ready() -> void:
	print(target)
	speed = 350
	damage = 3.0
	agent.set_target_position(Globals.player.global_position)

func _physics_process(delta: float) -> void:
	
	agent.set_target_position(Globals.player.global_position)
	
	var dir := position.direction_to(agent.get_next_path_position())
	
	var target_velocity := dir * speed * delta
	
	
	# Apply acceleration if there's input
	if dir != Vector2.ZERO:
		# Accelerate toward target velocity
		#velocity = velocity.lerp(target_velocity, get_physics_process_delta_time())
		#print("speed = ", velocity.length())
		position += target_velocity
	else:
		# Apply braking force (simulates deceleration)
		pass
