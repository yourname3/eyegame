extends Node2D
class_name ProtoProjectile

var velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta
