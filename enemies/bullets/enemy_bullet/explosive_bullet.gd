extends BasicBullet
class_name ExplosiveBullet



# the explosion





func _ready() -> void:
	speed = 280.0
	damage = 5.0





func _on_life_time_timeout():
	var new_explo = Globals.explosion.instantiate()
	new_explo.global_position = global_position
	add_sibling(new_explo)
	print('expl')
	queue_free()
