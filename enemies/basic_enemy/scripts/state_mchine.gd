extends AnimationTree
class_name BasicStateMachine




@export var signal_bus : BasicEnemy


var boost_cooldown : bool = true










func on_boost_cooldown():
	await get_tree().create_timer(5).timeout
	_set_boost_cooldown(true)
func _set_boost_cooldown(value:bool):
	boost_cooldown = value
