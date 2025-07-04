extends Node2D
class_name BasicSensory


@export var signal_bus : BasicEnemy

var vision_state : Globals.Status

var can_shoot : bool = true
@export var cooldown_timer : Timer


@export var target : Player
var death_explosion : bool = false
@export var attack_range : int 


@export var vision : Area2D
@export var agent : NavigationAgent2D
@export var hitbox : Area2D



func _ready() -> void:
	agent.set_target_position(signal_bus.global_position)


func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group('Players'):
		print("bdy entr cll")
		_set_target(body)
		match vision_state:
			Globals.Status.SUCCESS:
				_set_vision_state(Globals.Status.RUNNING)
			Globals.Status.RUNNING:
				pass
			Globals.Status.FAILURE:
				pass


func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group('Players'):
		match vision_state:
			Globals.Status.SUCCESS:
				pass
			Globals.Status.RUNNING:
				_set_vision_state(Globals.Status.SUCCESS)
			Globals.Status.FAILURE:
				_set_vision_state(Globals.Status.SUCCESS)


func _set_vision_state(new_state:Globals.Status):
	vision_state = new_state


func _set_target(new_target):
	target = new_target
func get_target():
	return target


func _on_agent_navigation_finished() -> void:
	match vision_state:
		Globals.Status.SUCCESS:
			agent.set_target_position(NavigationServer2D.region_get_random_point(Globals.nav_rid, 1, false))
		Globals.Status.RUNNING:
			pass
		Globals.Status.FAILURE:
			pass
