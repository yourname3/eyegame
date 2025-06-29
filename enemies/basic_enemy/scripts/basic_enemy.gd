extends CharacterBody2D
class_name BasicEnemy




signal use_engage
signal use_boost
signal boost_cooldown
signal use_skill
signal use_aggression

@export var sensory : BasicSensory
@export var stats : BasicStats
@export var state_machine : BasicStateMachine

@export var health : int
@export var speed : int
var speed_mod : float = 1.0
@export var strength : int
@onready var exp = preload("res://experience/exp.tscn")
@export var speed_boost : float





func _ready() -> void:
	sensory.target = get_parent().find_child("Player")
	use_engage.connect(on_use_engage)
	use_boost.connect(on_use_boost)
	boost_cooldown.connect(state_machine.on_boost_cooldown)

func _drop_exp(count: int) -> void:
	for i in range(count):
		var e = exp.instantiate()
		e.global_position = global_position + Vector2.from_angle(randf_range(0,TAU) ) * randf_range(.1,100)
		get_tree().root.add_child.call_deferred(e)
		#print("hello")

func _death():
	SignalBus.enemy_died.emit()
	
	# "10% to drop 5 extra xp", stacks by extra rolls
	for roll in range(0, Upgrades.rolls_for_extra_xp):
		if randf() <= 0.1:
			_drop_exp(5)
	
	_drop_exp(3)
	
	if sensory.death_explosion:
		var new_blowup
		new_blowup.global_position = global_position
		add_sibling(new_blowup)
		queue_free()
	else:
		queue_free()

func on_use_engage(new_vec):
	
	var dir := global_position.direction_to(new_vec)
	
	var target_velocity := dir * (get_speed() * get_speed_mod())
	
	
	# Apply acceleration if there's input
	if dir != Vector2.ZERO:
		# Accelerate toward target velocity
		velocity = velocity.lerp(target_velocity, get_physics_process_delta_time())
		#print("speed = ", velocity.length())
	else:
		# Apply braking force (simulates deceleration)
		pass
		
	move_and_slide()



func on_use_retreat(new_vec):
	var dir := global_position.direction_to(new_vec)
	
	var target_velocity := dir * (get_speed() * get_speed_mod()) * -1
	
	
	# Apply acceleration if there's input
	if dir != Vector2.ZERO:
		# Accelerate toward target velocity
		velocity = velocity.lerp(target_velocity, get_physics_process_delta_time())
		#print("speed = ", velocity.length())
	else:
		# Apply braking force (simulates deceleration)
		pass
		
	move_and_slide()

func on_use_boost():
	if state_machine.boost_cooldown:
		_set_speed_mod(speed_boost)
		state_machine._set_boost_cooldown(false)
		await get_tree().create_timer(.3).timeout
		_set_speed_mod(1)
		boost_cooldown.emit()
	else:
		pass


func on_use_skill():
	if state_machine.attack_one:
		var new_proj 
		new_proj.target = sensory.target
		new_proj.global_position = global_position.direction_to(sensory.agent.target_position)
		#add_sibling(new_proj)
		state_machine._set_attack_one(false)
		state_machine.on_attack_one()
	else:
		pass
	if state_machine.attack_two:
		var new_proj
		new_proj.global_position = global_position.direction_to(sensory.agent.target_position)
		add_sibling(new_proj)
		state_machine._set_attacK_two(false)
		state_machine.on_attacK_two()
	else:
		pass
	if state_machine.attack_three:
		var new_proj 
		var new_proj_one
		var new_proj_two
		var new_vec = global_position.direction_to(sensory.agent.target_position)
		var double_vec = new_vec
		new_proj.global_position = new_vec
		new_vec.rotated(TAU / 8)
		double_vec.rotated(-TAU / 8)
		new_proj_one.global_position = new_vec
		new_proj_two.global_position = double_vec
		#add_sibling(new_proj)
		#add_sibling(new_proj_one)
		#add_sibling(new_proj_two)
		state_machine._set_attack_three(false)
		state_machine.on_attacK_three()
	else:
		pass


func on_use_aggression():
	if state_machine.attack_two:
		var new_proj
		new_proj.global_position = global_position.direction_to(sensory.agent.target_position)
		add_sibling(new_proj)
		state_machine._set_attacK_two(false)
		state_machine.on_attacK_two()
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



func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group('Players'):
		Globals.transmit_damage.emit(body, get_strength())
		print('player damaged')
