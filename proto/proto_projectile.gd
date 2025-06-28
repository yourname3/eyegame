extends Node2D
class_name ProtoProjectile

var velocity = Vector2.ZERO
var speed := 0.0
var damage := 0.0
func _physics_process(delta: float) -> void:
	position += velocity * delta * speed


func _on_life_time_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemies"):
		Globals.transmit_damage.emit(body, 1)
		print(body.get_health())
		print("Implement Enemy Damage function in proto_projectile.gd")
