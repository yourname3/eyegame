extends CharacterBody2D
class_name BasicEnemy

signal use_velocity
signal use_boost

@export var sensory : BasicSensory
@export var stats : BasicStats
@export var state_machine : BasicStateMachine

@export var health : int
@export var speed : int
var speed_mod : float = 1.0
@export var strength : int
@onready var exp = preload("res://experience/exp.tscn")
func _ready() -> void:
	use_velocity.connect(on_use_velocity)
	use_boost.connect(on_use_boost)



func on_use_velocity():
	look_at(sensory.agent.get_next_path_position())
	set_global_position(global_position.move_toward(global_position + sensory.agent.get_next_path_position(), ((get_speed_mod() * get_speed()) * get_physics_process_delta_time())))

func on_use_boost():
	if state_machine.boost_cooldown:
		_set_speed_mod(1.5)
		state_machine._set_boost_cooldown(false)
		await get_tree().create_timer(.3).timeout
		_set_speed_mod(1)
	else:
		pass

func _set_health(value:int):
	if value < health:
		print("OUCH!")
		# If value is less than health, we're taking damage.
		# For now, do a simple red blink animation.
		var tween = create_tween()
		# Intense red
		tween.tween_property(self, "modulate", Color(2.0, 2.0, 2.0), 0.2)
		tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	health = value
	if health <= 0:
		_death()
func _set_speed(value:int):
	speed = value
func _set_speed_mod(value:float):
	speed_mod = value
func _set_strength(value:int):
	strength = value
func get_health() -> int:
	return health
func get_speed() -> int:
	return speed
func get_speed_mod() -> float:
	return speed_mod
func get_strength() -> int:
	return strength

func _death():
	for i in range(3):
		var e = exp.instantiate()
		e.global_position = global_position + Vector2.from_angle(randf_range(0,TAU) ) * randf_range(.1,100)
		get_tree().root.add_child.call_deferred(e)
		print("hello")
	queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group('Players'):
		Globals.transmit_damage.emit(body, get_strength())
