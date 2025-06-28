extends Node2D
class_name BlobEnemy

const POINTS := 32

@onready var inside: Polygon2D = %Inside
@onready var white_line: Line2D = %WhiteLine
@onready var outside: Polygon2D = %Outside
@onready var orange_line: Line2D = %OrangeLine

func _circle(x: float) -> float:
	return 1
	
func _bean(x: float, squish: float = 0.5) -> float:
	return 1 - squish * cos(2 * x + PI)

var noise_o = PackedVector2Array()

func _ready() -> void:
	for i in range(0, POINTS):
		noise_o.append(Vector2.ZERO)
	#var inside_polygon  := PackedVector2Array()
	#var outside_polygon := PackedVector2Array()
	#
	#for i in range(0, POINTS):
		#inside_polygon.append(Vector2.ZERO)
		#outside_polygon.append(Vector2.ZERO)
		#white_line.add_point(Vector2.ZERO)
		#orange_line.add_point(Vector2.ZERO)
	#
	#inside.polygon  = inside_polygon
	#outside.polygon = outside_polygon
	#inside.polygon = _make_circle(30, _bean)
	#outside.polygon = _make_circle()
	#white_line.points = _make_circle(30)
	#orange_line.points = _make_circle()
		
func _make_circle(radius: float = 80, callable: Callable = _circle) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(0, POINTS):
		# Don't use t [0, 1], because 0 point will be same as 1, so use t [0, 1)
		var t := float(i) / float(POINTS)
		points.append(Vector2.from_angle(t * TAU) * radius * callable.call(t * TAU))
	return points
	
func _make_ellipse(xr: float = 80, yr: float = 80) -> PackedVector2Array:
	var points = PackedVector2Array()
	for i in range(0, POINTS):
		var t := TAU * float(i) / float(POINTS)
		points.append(Vector2(xr * cos(t), yr * sin(t)))
	return points
		
var _bean_phase := 0.0
		
func _process(delta: float) -> void:
	var beanness = 0.5 + sin(_bean_phase) * 0.05
	var other_bean = sin(_bean_phase) * 0.05
	var fac1 = (1.0 + other_bean)
	var fac2 = (1.0 - other_bean)
	
	_bean_phase = fmod(_bean_phase + delta * TAU, TAU)
	
	for i in range(0, POINTS):
		var noise_unfil: Vector2 = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 80)
		noise_o[i] += (noise_unfil - noise_o[i]) * 0.02
	
	inside.polygon = _make_circle(60, _bean.bind(beanness))
	outside.polygon = _make_ellipse(120 * fac1, 80 * fac2)
	for i in range(0, POINTS):
		outside.polygon[i] += noise_o[i]
	white_line.points = _make_ellipse(60 * (1.0 + beanness), 60)
	orange_line.points = outside.polygon
