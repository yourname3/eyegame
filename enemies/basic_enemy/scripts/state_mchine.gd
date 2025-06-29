extends AnimationTree
class_name BasicStateMachine




@export var signal_bus : BasicEnemy


var boost_cooldown : bool = true

var attack_one : bool = true
var attack_two : bool = true
var attack_three : bool = true








func on_boost_cooldown():
	await get_tree().create_timer(5, false).timeout
	_set_boost_cooldown(true)
func _set_boost_cooldown(value:bool):
	boost_cooldown = value

func on_attack_one():
	await get_tree().create_timer(5, false).timeout
	_set_boost_cooldown(true)
func _set_attack_one(value:bool):
	attack_one = value
	
func on_attack_two():
	await get_tree().create_timer(1, false).timeout
	_set_boost_cooldown(true)
func _set_attack_two(value:bool):
	attack_two = value

func on_attacK_three():
	await get_tree().create_timer(3, false).timeout
	_set_boost_cooldown(true)
func _set_attack_three(value:bool):
	attack_three = value
