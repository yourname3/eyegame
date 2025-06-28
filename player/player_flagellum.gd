extends Line2D
class_name PlayerFlagellum

const POINT_COUNT = 32

func _ready() -> void:
	# We must have 2 points, the second one determines our size.
	assert(points.size() >= 2)
	var extent := points[1].x
	clear_points()
	
	var step = float(extent) / float(POINT_COUNT - 1)
	
	for i in range(0, POINT_COUNT):
		add_point(Vector2(step * i, 0))
		
	_phase = position.y * 3

var _phase := 0.0
var _phase_rate := randf_range(4.5, 5.5)

func _process(delta: float) -> void:
	_phase = fmod(_phase + delta * _phase_rate, TAU)
	for i in range(0, points.size()):
		points[i].y = sin(i * 0.3 + _phase) * i
