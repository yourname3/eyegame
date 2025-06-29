extends BasicSensory
class_name AmblyiopiaSensory







func _process(delta: float) -> void:
	match vision_state:
		Globals.Status.SUCCESS:
			if signal_bus.global_position != agent.target_position:
				signal_bus.look_at(agent.target_position)
				signal_bus.use_engage.emit(agent.get_next_path_position())
			else:
				agent.set_target_position(NavigationServer2D.region_get_random_point(Globals.nav_rid, 1, false))
				signal_bus.look_at(agent.get_next_path_position())
				signal_bus.use_engage.emit(agent.get_next_path_position())
		Globals.Status.RUNNING:
			if signal_bus.global_position.distance_to(target.global_position) <= attack_range:
				_set_vision_state(Globals.Status.FAILURE)
			else:
				agent.set_target_position(target.global_position)
				signal_bus.look_at(target.global_position)
				signal_bus.use_engage.emit(agent.get_next_path_position())
		Globals.Status.FAILURE:
			if signal_bus.global_position.distance_to(target.global_position) > attack_range:
				_set_vision_state(Globals.Status.RUNNING)
			else:
				
				agent.set_target_position(target.global_position)
				signal_bus.look_at(target.global_position)
				signal_bus.use_engage.emit(agent.get_next_path_position())
				signal_bus.use_boost.emit()
