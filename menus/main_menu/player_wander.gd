extends Node2D
## A little script that wanders around inside a ReferenceRect.
class_name PlayerWander

var next_target = Vector2.ZERO
var velocity = Vector2.ZERO

@onready var rect: Rect2 = get_parent().get_global_rect()

func _ready() -> void:
	_pick_target()

func _pick_target() -> void:
	next_target = Vector2(
		randf_range(rect.position.x, rect.end.x),
		randf_range(rect.position.y, rect.end.y))

func _physics_process(delta: float) -> void:
	var target_vel = (next_target - global_position).normalized() * 300
	velocity = velocity.move_toward(target_vel, 800 * delta)
	
	position += velocity * delta
	
	while global_position.distance_squared_to(next_target) < 20:
		_pick_target()
