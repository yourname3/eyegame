extends BasicSensory
class_name AmblyiopiaSensory

func _process(delta: float) -> void:
	match vision_state:
		Globals.Status.SUCCESS:
			agent.set_target_position(Globals.center_point)
			signal_bus.look_at(Globals.center_point)
			signal_bus.use_engage.emit(Globals.center_point)
		Globals.Status.RUNNING:
			if signal_bus.global_position.distance_to(target.global_position) <= attack_range:
				_set_vision_state(Globals.Status.FAILURE)
			else:
				agent.set_target_position(target.global_position)
				look_at(target.global_position)
				signal_bus.use_engage.emit(agent.target_position)
		Globals.Status.FAILURE:
			if signal_bus.global_position.distance_to(target.global_position) > attack_range:
				_set_vision_state(Globals.Status.RUNNING)
			else:
				
				agent.set_target_position(target.global_position)
				look_at(target.global_position)
				signal_bus.use_engage.emit(agent.target_position)
				signal_bus.use_boost.emit()
