extends BasicSensory
class_name CataractsSensory



func _ready() -> void:
	cooldown_timer.wait_time = 4.0


func _process(delta: float) -> void:
	if !target:
		target = Globals.player
	if target == null:
		# Once the player dies, we can't do anything anymore.
		return
	match vision_state:
		Globals.Status.SUCCESS:
			agent.set_target_position(target.global_position)
			signal_bus.look_at(agent.target_position)
			signal_bus.use_engage.emit(agent.get_next_path_position())
		Globals.Status.RUNNING:
			agent.set_target_position(target.global_position)
			signal_bus.look_at(agent.target_position)
			signal_bus.use_engage.emit(agent.get_next_path_position())
			if cooldown_timer.is_stopped():
				signal_bus.use_aggression.emit()
				cooldown_timer.start()
			else:
				pass
		Globals.Status.FAILURE:
			agent.set_target_position(target.global_position)
			signal_bus.look_at(agent.target_position)
			signal_bus.use_engage.emit(agent.get_next_path_position())
			signal_bus.use_boost.emit()
