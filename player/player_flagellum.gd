extends Line2D
class_name PlayerFlagellum

const POINT_COUNT = 32

var global_points := PackedVector2Array()
var source_points := PackedVector2Array()
var offsets       := PackedVector2Array()

func _ready() -> void:
	# We must have 2 points, the second one determines our size.
	assert(points.size() >= 2)
	var extent := points[1].x
	clear_points()
	
	var step = float(extent) / float(POINT_COUNT - 1)
	
	for i in range(0, POINT_COUNT):
		add_point(Vector2(step * i, 0))
		source_points.append(Vector2(step * i, 0))
		global_points.append(global_transform * Vector2(step * i, 0))
		offsets.append(Vector2.ZERO)
		
	_phase = position.y * 3

var _phase := 0.0
var _phase_rate := randf_range(4.5, 5.5)

func _process(delta: float) -> void:
	_phase = fmod(_phase + delta * _phase_rate, TAU)
	var inv = global_transform.inverse()
	
	# Update offsets
	for i in range(points.size() - 1, 0, -1):
		offsets[i] = offsets[i - 1]
	offsets[0] = get_parent()._position_delta
	
	# Compute following thing
	for i in range(0, points.size()):
		global_points[i] = global_transform * (source_points[i] + offsets[i])
		
	
	
	for i in range(0, points.size()):
		points[i] = inv * global_points[i]
		#points[i].y = sin(i * 0.3 + _phase) * i
