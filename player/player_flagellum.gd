extends Line2D
class_name PlayerFlagellum

const POINT_COUNT = 32

var global_points := PackedVector2Array()
var truth         := PackedVector2Array()
var vels          := PackedVector2Array()

# The local coordinate of the root point.
const ROOT := Vector2.ZERO

var step := 0.0

func _ready() -> void:
	# We must have 2 points, the second one determines our size.
	assert(points.size() >= 2)
	var extent := points[1].x
	clear_points()
	
	step = float(extent) / float(POINT_COUNT - 1)
	
	for i in range(0, POINT_COUNT):
		add_point(Vector2(step * i, 0))
		global_points.append(global_transform * Vector2(step * i, 0))
		truth.append(Vector2(step * i, 0))
		vels.append(Vector2.ZERO)
		
	_phase = position.y * 3

var _phase := 0.0
var _phase_rate := randf_range(4.5, 5.5) * 3

var idle_noise := Vector2.ZERO

func _process(delta: float) -> void:
	_phase = fmod(_phase + delta * _phase_rate, TAU)
	var inv := global_transform.inverse()
	
	var amp := remap(get_parent().position_delta.length(), 0.0, 400.0 / 60.0, 0.0, 20.0)
	
	#global_points[0] = global_transform * (ROOT + Vector2(0, sin(_phase) * amp))
	
	for i in range(0, points.size()):
		var t := float(i) / float(points.size() - 1)
		t = 1.0 - (abs(t - 0.25) * 2.0)
		var amp_i := t * amp
		truth[i].y = sin(i * 0.3 + _phase) * amp_i
	global_points[0] = global_transform * truth[0]
	
	var noise = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 40)
	idle_noise += (noise - idle_noise) * 0.02
	for i in range(1, points.size()):
		global_points[i] += vels[i].orthogonal() * delta + idle_noise * delta
	
	for i in range(1, points.size()):
		var global_truth = global_transform * truth[i]
		
		var accel = spring(global_points[i], global_points[i - 1], step) + \
			spring(global_points[i], global_truth, 0.0, 20) + \
			spring_damp(vels[i])
		vels[i] += accel * delta
		global_points[i] += vels[i] * delta
		
	var maxstep = step * 1.2
		
	for i in range(1, points.size()):
		var to_last = global_points[i] - global_points[i - 1]
		if to_last.length_squared() > (maxstep * maxstep):
			global_points[i] = global_points[i - 1] + to_last.normalized() * maxstep

	for i in range(0, points.size()):
		points[i] = inv * global_points[i]
		#
		
func spring_damp(vel: Vector2, B: float = 10) -> Vector2:
	return -B * vel

func spring(pos: Vector2, o_pos: Vector2, length: float, K: float = 100) -> Vector2:
	# Direction from other to current pos.
	var x = pos - o_pos
	if x.length_squared() < 0.00000001:
		return Vector2.ZERO
	
	# Project our spring length along that.
	var rest = length * x.normalized()
	
	# F = -(x - rest)
	var accel = -K * (x - rest)
	
	return accel
