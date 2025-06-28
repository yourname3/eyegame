extends Node2D
# Nominally some kind of weapon equip point, that autonomously aims.
class_name PlayerClaw

# Local coordinates, random wandering target position.
var target: Vector2 = Vector2.ZERO

var smooth1: Vector2 = Vector2.ZERO
var smooth2: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	const fac = 0.1
	var noise = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 500)
	smooth1 += (noise - smooth1) * fac
	smooth2 += (smooth1 - smooth2) * fac
	target += (smooth2 - target) * fac
	
	position = position.move_toward(target, 300 * delta)
	global_rotation = rotate_toward(global_rotation, target.angle(), TAU * delta * 8)
