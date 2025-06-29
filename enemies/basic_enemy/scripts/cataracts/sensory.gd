extends BasicSensory
class_name CataractsSensory






func _process(delta: float) -> void:
	match vision_state:
		Globals.Status.SUCCESS:
			agent.set_target_position(target.global_position)
			signal_bus.use_engage.emit(target.global_position)
		Globals.Status.RUNNING:
			agent.set_target_position(target.global_position)
			signal_bus.use_skill.emit()
			signal_bus.use_engage.emit(target.global_position)
		Globals.Status.FAILURE:
			agent.set_target_position(target.global_position)
			signal_bus.use_engage.emit(target.global_position)
			signal_bus.use_boost.emit()
