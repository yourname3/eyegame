extends CharacterBody2D
class_name BasicEnemy


@export var self_to_spawn: PackedScene = null

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
@export var speed_boost : float


@export var target : Player

var _spawn_in_tween: Tween = null


func _ready() -> void:
	sensory.target = get_parent().find_child("Player")
	use_engage.connect(on_use_engage)
	use_boost.connect(on_use_boost)
	use_skill.connect(on_use_skill)
	use_aggression.connect(on_use_aggression)
	boost_cooldown.connect(state_machine.on_boost_cooldown)
	
	
	# Update health based on upgrades
	health = int(float(health) * Upgrades.enemy_health_multiplier)
	
	scale = Vector2.ZERO
	modulate = Color(1, 1, 1, 0)
	_spawn_in_tween = create_tween()
	_spawn_in_tween.tween_property(self, "scale", Vector2.ONE * Upgrades.enemy_scale_multiplier, 0.3)
	_spawn_in_tween.set_parallel().tween_property(self, "modulate", Color.WHITE, 0.1)

func _drop_exp(count: int) -> void:
	for i in range(count):
		var e = preload("res://experience/exp.tscn").instantiate()
		e.global_position = global_position + Vector2.from_angle(randf_range(0,TAU) ) * randf_range(.1,100)
		get_node("/root/Game").add_child.call_deferred(e)
		#get_node("/root/Game").add_child.call_deferred(e)
		#print("hello")

var _died = false

func _spawn_copy():
	if self_to_spawn != null:
		var copy = self_to_spawn.instantiate()
		copy.global_position = global_position
		add_sibling(copy)

func _disable_area(area: Area2D) -> void:
	if area != null:
		area.collision_layer = 0
		area.collision_mask = 0

func _die_tween():
	var t = create_tween()
	t.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.3)
	t.tween_callback(self.queue_free)
	
	# Make sure we can't collide with anything
	if sensory:
		_disable_area(sensory.vision)
		_disable_area(sensory.hitbox)
	collision_layer = 0
	collision_mask = 0
		
	#process_mode = Node.PROCESS_MODE_DISABLED

func _death():
	if _died:
		return
	_died = true
	
	var death_position : Vector2 = global_position
	Sounds.sfx_enemy_death.play()
	SignalBus.enemy_died.emit()
	
	# "10% to drop 5 extra xp", stacks by extra rolls
	for roll in range(0, Upgrades.rolls_for_extra_xp):
		if randf() <= 0.08:
			_drop_exp(3)
			
	for roll in range(0, Upgrades.enemy_spawn_rolls):
		if randf() <= 0.04:
			_spawn_copy()
	
	_drop_exp(3)
	if sensory.death_explosion:
		var new_blowup = Globals.explosion.instantiate()
		new_blowup.global_position = death_position
		add_sibling.call_deferred(new_blowup)
		#queue_free()
		_die_tween()
	else:
		#queue_free()
		_die_tween()

func on_use_engage(new_vec):
	
	var dir := global_position.direction_to(new_vec)
	
	var target_velocity := dir * (get_modded_speed())
	
	
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
	
	var target_velocity := dir * (get_modded_speed()) * -1
	
	
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
		await get_tree().create_timer(.3, false).timeout
		_set_speed_mod(1)
		boost_cooldown.emit()
	else:
		pass


func on_use_skill():
	var new_proj = Globals.explosive_bullet.instantiate()
	var new_proj_two = Globals.explosive_bullet.instantiate()
	var new_proj_three = Globals.explosive_bullet.instantiate()
	new_proj.global_position = (global_position + global_position.direction_to(sensory.agent.target_position))
	new_proj.direction = global_position.direction_to(sensory.agent.target_position)
	new_proj.look_at(sensory.agent.target_position)
	new_proj_two.global_position = (global_position + global_position.direction_to(sensory.agent.target_position))
	new_proj_two.direction = global_position.direction_to(sensory.agent.target_position)
	new_proj_two.look_at(sensory.agent.target_position)
	new_proj_three.global_position = (global_position + global_position.direction_to(sensory.agent.target_position))
	new_proj_three.direction = global_position.direction_to(sensory.agent.target_position)
	new_proj_three.look_at(sensory.agent.target_position)
	add_sibling(new_proj)
	await get_tree().create_timer(0.3, false).timeout
	add_sibling(new_proj_two)
	await get_tree().create_timer(0.7, false).timeout
	add_sibling(new_proj_three)


	var new_proj_good = Globals.enemy_bullet.instantiate()
	new_proj_good.global_position = global_position + global_position.direction_to(sensory.agent.target_position)
	new_proj_good.direction = global_position.direction_to(sensory.agent.target_position)
	new_proj_good.look_at(sensory.agent.target_position)
	add_sibling(new_proj_good)

	var new_proj_fly = Globals.homing_bullet.instantiate()
	var new_proj_up = Globals.curly_bullet.instantiate()
	var new_proj_slo = Globals.curly_bullet.instantiate()
	var new_vec = global_position.direction_to(sensory.agent.target_position)
	var double_vec = new_vec
	new_proj_fly.global_position = global_position + global_position.direction_to(sensory.agent.target_position)
	new_proj_fly.agent.set_target_position(sensory.agent.target_position)
	new_vec.rotated(TAU / 8)
	double_vec.rotated(-TAU / 8)
	new_proj_up.global_position = new_vec
	new_proj_up.target_position = sensory.agent.target_position
	new_proj_slo.global_position = double_vec
	new_proj_slo.target_position = sensory.agent.target_position
	new_proj_slo.side_aim = false
	new_proj_fly.look_at(sensory.agent.target_position)
	new_proj_up.look_at(sensory.agent.target_position)
	new_proj_slo.look_at(sensory.agent.target_position)
	add_sibling(new_proj_fly)
	add_sibling(new_proj_up)
	add_sibling(new_proj_slo)



func on_use_aggression():
	var new_proj = Globals.heavy_bullet.instantiate()
	new_proj.global_position = global_position + global_position.direction_to(sensory.agent.target_position)
	new_proj.direction = global_position.direction_to(sensory.agent.target_position)
	add_sibling(new_proj)


func _set_health(value:int):
	if value < health:
		Sounds.sfx_enemy_hit.play()
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
func get_modded_speed() -> float:
	return get_speed() * get_speed_mod() * Upgrades.enemy_speed_multiplier
func get_strength() -> int:
	return strength


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group('Players'):
		Globals.transmit_damage.emit(body, get_strength())

func _process(delta: float) -> void:
	# This could be moved to a signal that only updates when upgrades are chosen,
	# but whatever.
	if not _spawn_in_tween.is_running():
		scale.x = Upgrades.enemy_scale_multiplier
		scale.y = scale.x


func _on_timer_timeout() -> void:
	sensory.can_shoot = true
