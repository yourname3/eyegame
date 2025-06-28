extends Node
## Contains helper functions for performing spring math.
## Not a real autoload, just has static functions.
class_name Spring

static func spring_damp(vel: Vector2, B: float = 10) -> Vector2:
	return -B * vel

static func spring(pos: Vector2, o_pos: Vector2, length: float, K: float = 100) -> Vector2:
	# Direction from other to current pos.
	var x = pos - o_pos
	if x.length_squared() < 0.00000001:
		return Vector2.ZERO
	
	# Project our spring length along that.
	var rest = length * x.normalized()
	
	# F = -(x - rest)
	var accel = -K * (x - rest)
	
	return accel
