extends BasicSensory
class_name ConjunctivitisSensory







func _process(delta: float) -> void:
	match vision_state:
		Globals.Status.SUCCESS:
			pass
		Globals.Status.RUNNING:
			agent.set_target_position(target.global_position)
			signal_bus.use_velocity.emit()
		Globals.Status.FAILURE:
			agent.set_target_position(target.global_position)
			signal_bus.use_velocity.emit()
