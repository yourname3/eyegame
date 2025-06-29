extends BasicSensory
class_name UveitisSensory



func _ready() -> void:
	cooldown_timer.wait_time = 6.0


func _process(delta: float) -> void:
	if cooldown_timer.is_stopped():
		#print('yes')
		pass
	
	if !target:
			target = Globals.player
	match vision_state:
		Globals.Status.SUCCESS:
			agent.set_target_position(target.position)
			signal_bus.use_engage.emit(agent.get_next_path_position())
		Globals.Status.RUNNING:
			agent.set_target_position(target.global_position)
			if cooldown_timer.is_stopped():
				signal_bus.use_skill.emit()
				cooldown_timer.start()
			else:
				pass
		Globals.Status.FAILURE:
			agent.set_target_position(target.global_position)
			signal_bus.use_retreat.emit(agent.get_next_path_position())
