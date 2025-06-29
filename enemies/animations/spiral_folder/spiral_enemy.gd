extends Node2D
class_name SpiralEnemy

@onready var line: Line2D = %Line

const POINTS := 128
const MAX_T = 12 * PI

# Desmos source of this:
# https://www.desmos.com/calculator/ytutiy5hmp
# \left(\cos\left(t+a\right),0.5\left(0.3t+\sin\left(t+a\right)\right)\right)

func _ready() -> void:
	line.clear_points()
	
	for i in range(0, POINTS):
		line.add_point(Vector2.ZERO)
		
	_draw_spiral(0, 0)
		
func _draw_spiral(phase: float, funny_phase: float) -> void:
	for i in range(0, line.points.size()):
		var t := (float(i) / float(line.points.size() - 1)) * MAX_T
		
		var point = Vector2(0.5 * (0.3 * t + sin(t + phase)), cos(t + phase))
		point.y += sin((t + funny_phase)/PI) * 0.2
		point *= 30
		
		line.points[i] = point

var _funny_phase := 0.0
var _phase := 0.0

var _last_position = global_position

func _process(delta: float) -> void:
	var position_dif = global_position - _last_position
	var speed = position_dif.length() / delta
	if delta <= 0.0:
		speed = 0.0 # idk
	

	var phase_step = speed / (30 * 0.5 * 0.3)
	
	_draw_spiral(_phase, _funny_phase)
	_phase = fmod(_phase + phase_step * delta, TAU)
	
	_funny_phase = fmod(_funny_phase + TAU * delta, PI * PI * 2.0)
	
	_last_position = global_position
