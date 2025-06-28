extends Node2D
# Nominally some kind of weapon equip point, that autonomously aims.
class_name PlayerClaw

# Local coordinates, random wandering target position.
var target: Vector2 = Vector2.ZERO

var smooth1: Vector2 = Vector2.ZERO
var smooth2: Vector2 = Vector2.ZERO

const POINT_COUNT = 32
var global_points := PackedVector2Array()
var vels          := PackedVector2Array()

@export var line_color := Color("#3f3f3f")

# The root pos is where we are "attached" on the player model.
# We must transform it into global position using our parent's transform.
@onready var root_pos = position

@onready var line: Line2D = $Line2D

func _ready() -> void:
	# Put the circle at the "base" of the claw onto the parent
	$ClawBase.reparent.call_deferred(get_parent())
	line.clear_points()
	
	for i in range(0, POINT_COUNT):
		line.add_point(Vector2.ZERO)
		global_points.append(Vector2.ZERO)
		vels.append(Vector2.ZERO)
		
	line.default_color = line_color
		
func _process_points(delta: float) -> void:	
	var inv := line.global_transform.inverse()

	global_points[0]                        = root_pos
	global_points[global_points.size() - 1] = position
	
	const SPRING_LENGTH = 0.2
	
	for i in range(1, global_points.size() - 1):
		var accel = spring(global_points[i], global_points[i - 1], SPRING_LENGTH) + \
			spring(global_points[i], global_points[i + 1], SPRING_LENGTH) + \
			spring_damp(vels[i])
		vels[i] += accel * delta
		global_points[i] += vels[i] * delta
		
	#for i in range(1, points.size()):
	#	var to_last = global_points[i] - global_points[i - 1]
	#	if to_last.length_squared() > (maxstep * maxstep):
	#		global_points[i] = global_points[i - 1] + to_last.normalized() * maxstep

	for i in range(0, global_points.size()):
		line.points[i] = inv * get_parent().global_transform * global_points[i]
		#
		
func spring_damp(vel: Vector2, B: float = 20) -> Vector2:
	return -B * vel

func spring(pos: Vector2, o_pos: Vector2, length: float, K: float = 800) -> Vector2:
	# Direction from other to current pos.
	var x = pos - o_pos
	if x.length_squared() < 0.00000001:
		return Vector2.ZERO
	
	# Project our spring length along that.
	var rest = length * x.normalized()
	
	# F = -(x - rest)
	var accel = -K * (x - rest)
	
	return accel

func _process(delta: float) -> void:
	const fac = 0.1
	var noise = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 500)
	smooth1 += (noise - smooth1) * fac
	smooth2 += (smooth1 - smooth2) * fac
	target += (smooth2 - target) * fac
	
	position = position.move_toward(target, 300 * delta)
	global_rotation = rotate_toward(global_rotation, target.angle(), TAU * delta * 8)
	
	var inv := line.global_transform.inverse()
	for i in range(0, global_points.size()):
		line.points[i] = inv * get_parent().global_transform * global_points[i]
	
func _physics_process(delta: float) -> void:
	_process_points(delta)
