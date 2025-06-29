extends Node2D
# Nominally some kind of weapon equip point, that autonomously aims.
class_name PlayerClaw

# Local coordinates, random wandering target position.
var target: Vector2 = Vector2.ZERO

var smooth1: Vector2 = Vector2.ZERO
var smooth2: Vector2 = Vector2.ZERO

const POINT_COUNT = 5
const INTERP_COUNT = 32
var global_points := PackedVector2Array()
var vels          := PackedVector2Array()

@export var line_color := Color("#3f3f3f")
#This is how far left or right the arm aims for based on the mouse position
@export var angle_offset := 5.0
@export var arm_length := 70
@export var is_left = false

# The root pos is where we are "attached" on the player model.
# We must transform it into global position using our parent's transform.
@onready var root_pos = position

@onready var line: Line2D = $Line2D
#@onready var fire_point := %FirePoint

@onready var claw_root := $ClawRoot
@onready var weapons := [preload("res://player/weapons/base_gun.tscn"), preload("res://player/weapons/machine_gun.tscn"), preload("res://player/weapons/shot_gun.tscn")]
var weapon_idx : int = 0
var weapon_knockback := Vector2.ZERO

#func _shoot() -> void:
	#var bullet = preload("res://proto/proto_projectile.tscn").instantiate()
	#
	## We use OUR global rotation, as we're facing in the direction of the gun.
	#
	#bullet.velocity = (gun.global_position - get_global_mouse_position()).normalized() #.from_angle(global_rotation) * 600.0
	## The claw's parent is the player; add a sibling to the player.
	#get_parent().add_sibling(bullet)
	#bullet.global_position = fire_point.global_position

func _ready() -> void:
	if weapons[weapon_idx]:
		var weapon = weapons[weapon_idx].instantiate()
		weapon.weapon_idx = weapon_idx
		weapon.is_left = is_left
		$ClawRoot.add_child(weapon)

	# Put the circle at the "base" of the claw onto the parent
	$ClawBase.reparent.call_deferred(get_parent())
	line.clear_points()
	
	for i in range(0, POINT_COUNT):
		#line.add_point(Vector2.ZERO)
		global_points.append(Vector2.ZERO)
		vels.append(Vector2.ZERO)
		
	for i in range(0, INTERP_COUNT):
		line.add_point(Vector2.ZERO)
		
	line.default_color = line_color
		
func _process_points(delta: float) -> void:
	var inv := line.global_transform.inverse()

	global_points[0]                        = root_pos
	global_points[global_points.size() - 1] = transform * claw_root.position
	
	const SPRING_LENGTH = 0.2
	
	for i in range(1, global_points.size() - 1):
		var accel = Spring.spring(global_points[i], global_points[i - 1], SPRING_LENGTH) + \
			Spring.spring(global_points[i], global_points[i + 1], SPRING_LENGTH) + \
			Spring.spring_damp(vels[i])
		vels[i] += accel * delta
		global_points[i] += vels[i] * delta
		

	#for i in range(1, points.size()):
	#	var to_last = global_points[i] - global_points[i - 1]
	#	if to_last.length_squared() > (maxstep * maxstep):
	#		global_points[i] = global_points[i - 1] + to_last.normalized() * maxstep
		


func _process(delta: float) -> void:
	if $ClawRoot.get_children()[0].unequip:
		print("UNEQUIP ME FROM CLAW?")
		change_weapon(-1)
	const fac = 0.1
	var noise = Vector2.from_angle(randf_range(0, TAU)) * randf_range(0, 500)
	smooth1 += (noise - smooth1) * fac
	smooth2 += (smooth1 - smooth2) * fac
	#target += (smooth2 - target) * fac
	
	var to_mouse = get_global_mouse_position() - global_position
	var ang_off = 0

	if abs(rad_to_deg(to_mouse.angle() - get_parent().global_rotation)) > 90:
		ang_off = -angle_offset
	else:
		ang_off = angle_offset
		#TODO: Fix the bottom left quadrant arm crossover.
	if is_left:
		pass
	var angle_with_offset = to_mouse.angle() + deg_to_rad(ang_off)
	
	target = get_parent().global_position + Vector2.from_angle(angle_with_offset) * arm_length
	target += weapon_knockback
	weapon_knockback *= .6
	global_position = global_position.move_toward(target, 300 * delta)
	global_rotation = rotate_toward(global_rotation, target.angle(), TAU * delta * 8)
	
	#Detect inputs for weapon switching. 
	if is_left && Input.is_action_just_pressed("SwitchWeaponLeft"):
		change_weapon(1) 
	elif !is_left && Input.is_action_just_pressed("SwitchWeaponRight"):
		change_weapon(1) 
	
	_render_points()
	
func _smooth_points() -> void:
	var smoothed := line.points
	for i in range(1, line.points.size() - 1):
		smoothed[i] = line.points[i - 1] * 0.25 + line.points[i] * 0.5 + line.points[i + 1] * 0.25
	
	line.points = smoothed
	
func _render_points() -> void:
	var inv := line.global_transform.inverse()
	
	var tformed := PackedVector2Array()
	
	for i in range(0, POINT_COUNT):
		tformed.append(inv * get_parent().global_transform * global_points[i])
		
	const chunk = (INTERP_COUNT / (POINT_COUNT - 1))
	
	for i in range(0, line.points.size()):
		var a = i / chunk
		var b = a + 1
		var t = float(i - (a * chunk)) / float(chunk - 1)
		line.points[i] = lerp(tformed[a], tformed[b], t)
		
	for i in range(0, 3):
		_smooth_points()
	
func _physics_process(delta: float) -> void:
	_process_points(delta)


func change_weapon(inc):
	weapon_idx = weapon_idx + inc
	weapon_idx = weapon_idx % weapons.size()
	while !Globals.OWNED_WEAPONS[weapon_idx]:
		print("Current WEapon index: ", weapon_idx)
		weapon_idx = (weapon_idx + inc) % weapons.size()
		print("After Changign : ", weapon_idx)
	if weapons[weapon_idx] and Globals.OWNED_WEAPONS[weapon_idx]:
		var old_rot = 0
		for i in $ClawRoot.get_children():
			old_rot = i.global_rotation
			i.queue_free()
		var weapon = weapons[weapon_idx].instantiate()
		weapon.global_rotation = old_rot
		weapon.weapon_idx = weapon_idx
		weapon.is_left = is_left

		$ClawRoot.add_child(weapon)
	
