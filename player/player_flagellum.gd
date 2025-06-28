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
var _phase_rate := randf_range(4.5, 5.5)

var idle_noise := Vector2.ZERO

func _process(delta: float) -> void:
	
	var inv := global_transform.inverse()
	
	var speed_control := remap(get_parent().position_delta.length(), 0.0, 600.0 / 60.0, 0.0, 1.0)
	
	var amp: float = lerp(5.0, 20.0, speed_control)
	#var maxstep: float = lerp(1.2, 2.0, speed_control) * step
	var maxstep := 1.2 * step
	
	var phase_speedup = lerp(1.0, 7.0, speed_control) 
	
	_phase = fmod(_phase + delta * _phase_rate * phase_speedup, TAU)
	
	#global_points[0] = global_transform * (ROOT + Vector2(0, sin(_phase) * amp))
	
	for i in range(0, points.size()):
		var t := float(i) / float(points.size() - 1)
		t = 1.0 - (abs(t - 0.4) * 2.0)
		var amp_i := t * amp
		truth[i].y = sin(i * 0.3 * phase_speedup + _phase) * amp#_i
	global_points[0] = global_transform * truth[0]
	
	var noise = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 40)
	idle_noise += (noise - idle_noise) * 0.02
	for i in range(1, points.size()):
		global_points[i] += idle_noise * delta # + vels[i].orthogonal() * delta
	
	for i in range(1, points.size()):
		var global_truth = global_transform * truth[i]
		
		var t := float(i) / float(points.size() - 1)
		var truth_springiness = lerp(60, 1, t)
		
		var accel = spring(global_points[i], global_points[i - 1], step) + \
			spring(global_points[i], global_truth, 0.0, truth_springiness) + \
			spring_damp(vels[i])
		vels[i] += accel * delta
		global_points[i] += vels[i] * delta
		
	for i in range(1, points.size()):
		var to_last = global_points[i] - global_points[i - 1]
		if to_last.length_squared() > (maxstep * maxstep):
			global_points[i] = global_points[i - 1] + to_last.normalized() * maxstep
			
	#var diff = global_points[0] - (global_transform * ROOT)
	#for i in range(0, points.size()):
		#global_points[i] -= diff
		
	#global_points[0] = global_transform * ROOT
	#for i in range(0, 15):
		#_smooth_points()

	for i in range(0, points.size()):
		points[i] = inv * global_points[i]
		
func _smooth_points() -> void:
	var smoothed := points
	for i in range(1, points.size() - 1):
		smoothed[i] = points[i - 1] * 0.25 + points[i] * 0.5 + points[i + 1] * 0.25
	
	points = smoothed
		
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
