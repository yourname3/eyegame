extends BasicBullet
class_name HomingBullet




@export var agent : NavigationAgent2D 
var target : Player 

func _ready() -> void:
	print(target)
	speed = 350
	damage = 3.0
	agent.set_target_position(target.global_position)

func _physics_process(delta: float) -> void:
	position += position.direction_to(agent.get_next_path_position()) * speed * delta
	agent.set_target_position(target.global_position)
	
