extends BasicBullet
class_name HomingBullet




@export var agent : NavigationAgent2D 



func _ready() -> void:
	speed = 350
	damage = 3.0

func _physics_process(delta: float) -> void:
	position += position.direction_to(agent.get_next_path_position()) * speed * delta
