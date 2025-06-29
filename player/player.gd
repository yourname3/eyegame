extends CharacterBody2D
class_name Player

@export var speed := 700
@export var brake_force := 0.94
@export var acceleration := 15.0
var level : int = 0
var current_exp : int = 0
var needed_exp : int = 1
@export var health : int = 100


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

	move_and_slide()

func _set_health(value:int):
	if value < health:
		SignalBus.player_damaged.emit()
	health = value
	if health <= 0:
		_death()
func get_health() -> int:
	return health

func _death():
	queue_free()


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

func check_level_up():
	if current_exp >= needed_exp:
		level += 1
		current_exp = 0
		needed_exp = needed_exp * 2
		print("level: ", level)
	
