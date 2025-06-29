extends Node



signal transmit_damage(body, amount)

enum Status {
	SUCCESS,
	RUNNING,
	FAILURE
}

enum NetStatus {
	README, # do not call
	SUCCESS, # keep the same
	RUNNING, # change 
	FAILURE, # code fails to run
	ERROR # error code
}


var nav_rid
var center_point : Vector2 = Vector2(2448.0, 434.0)



func _ready() -> void:
	transmit_damage.connect(receive_damage)


func receive_damage(target, damage:int):
	target._set_health(target.get_health() - damage)
