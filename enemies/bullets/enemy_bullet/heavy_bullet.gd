extends BasicBullet
class_name HeavyBullet





func _ready() -> void:
	speed = 375.0
	damage = 4.0
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Players'):
		Globals.transmit_damage.emit(body, damage)
		queue_free()
