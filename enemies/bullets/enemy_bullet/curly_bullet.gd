extends BasicBullet
class_name CurlyBullet


# angular motion
@export var path : Path2D
@export var path_follow : PathFollow2D
var target_position : Vector2 = Vector2.ZERO
var side_aim : bool = true



func _ready() -> void:
	speed = 275.0
	damage = 2.0
	if side_aim:
		path.curve.set_point_out(1, Vector2(0, 300))
	else:
		path.curve.set_point_out(1, Vector2(0, -300))
	path.curve.set_point_position(1, target_position)
	if target_position == Vector2.ZERO:
		return


func _physics_process(delta: float) -> void:
	
	path_follow.progress += speed * delta
