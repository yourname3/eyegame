extends CharacterBody2D
class_name Player

@export var speed := 700
@export var brake_force := 0.94
@export var acceleration := 15.0
var level : int = 0
var current_exp : int = 0
var needed_exp : int = 1
@export var health : int = 60
@onready var max_health: int = health

var _damage_tween: Tween = null

func _create_damage_tween() -> void:
	if _damage_tween != null:
		_damage_tween.kill()
		_damage_tween = null
	_damage_tween = create_tween()
	var c := Color(1.0, 0.5, 0.5)
	_damage_tween.tween_property(self, "modulate", c, 0.2)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_damage_tween.tween_property(self, "modulate", Color.WHITE, 0.2)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_damage_tween.tween_property(self, "modulate", c, 0.2)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_damage_tween.tween_property(self, "modulate", Color.WHITE, 0.2)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func get_input() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _physics_process(delta: float) -> void:
	var dir := get_input().normalized()
	var target_velocity := dir * speed

	# Apply acceleration if there's input
	if dir != Vector2.ZERO:
		# Accelerate toward target velocity
		velocity = velocity.lerp(target_velocity, acceleration * delta)
		#print("speed = ", velocity.length())
	else:
		# Apply braking force (simulates deceleration)
		velocity *= brake_force
	#print(level)
	move_and_slide()

func _set_health(value:int):
	if value > max_health:
		# TODO: Do we want overheal?
		value = max_health
	
	if value < health:
		# If we have a valid running damage tween, we are invincible, this
		# gives us nice little invincibility.
		if _damage_tween != null and _damage_tween.is_running():
			return
		
		SignalBus.player_damaged.emit()
		Sounds.sfx_player_hit.play()
		_create_damage_tween()
	health = value
	print("Player took damage! ", health)
	if Globals.game_ui_ref:
		Globals.game_ui_ref.set_player_health_ui(health,max_health)
	if health <= 0:
		_death()
	
func get_health() -> int:
	return health

func _death():
	# Don't free the player, there is no reason to.
	SceneTransition.change_scene_to_packed(preload("res://game_over_screen.tscn"), "gameover")

func _ready():
	_compute_needed_exp()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Experience"):
		body.fly = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Experience"):
		body.fly = false


func _on_exp_collect_body_entered(body: Node2D) -> void:
	if body.is_in_group("Experience"):
		body.queue_free()
		current_exp+=1
		print(current_exp)
		check_level_up()
		Sounds.sfx_exp_collect.play()
		
func _compute_needed_exp():
	var x = (level + 1) # experience to the next level, e.g. when level = 0 we get x = 1
	needed_exp = int(14 * pow(1.1, x))

func check_level_up():
	if Globals.game_ui_ref:
		Globals.game_ui_ref.set_player_level(current_exp, needed_exp)
	if current_exp >= needed_exp:
		level += 1
		current_exp = 0
		_compute_needed_exp()
		SignalBus.level_up.emit()
		print("level: ", level)
