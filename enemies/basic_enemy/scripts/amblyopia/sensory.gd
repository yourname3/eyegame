extends BasicSensory
class_name AmblyiopiaSensory









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
			if signal_bus.state_machine.boost_cooldown:
				signal_bus.use_boost.emit()
			else:
				pass
