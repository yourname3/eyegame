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
		
	_draw_spiral(0)
		
func _draw_spiral(phase: float) -> void:
	for i in range(0, line.points.size()):
		var t := (float(i) / float(line.points.size() - 1)) * MAX_T
		
		var point = Vector2(cos(t + phase), 0.5 * (0.3 * t + sin(t + phase)))
		point *= 30
		
		line.points[i] = point

var _phase := 0.0

func _process(delta: float) -> void:
	var speed = 100.0
	
	position.y += speed * delta
	
	var phase_step = speed / (30 * 0.5 * 0.3)
	
	_draw_spiral(_phase)
	_phase = fmod(_phase + phase_step * delta, TAU)
