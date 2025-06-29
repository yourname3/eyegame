extends Area2D
class_name BasicBullet


var direction = Vector2.ZERO
var speed := 0.0
var damage := 0.0
func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed


func _on_life_time_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Players"):
		Globals.transmit_damage.emit(body, damage)
	else:
		pass
