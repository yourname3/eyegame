extends Gun

#var bullet_count   : int   = 6   
@export var spread_degrees : float = 18.0   # full cone width (degrees)

func _physics_process(delta: float) -> void:
	if is_left && check_can_shoot() && Input.is_action_pressed("ShootLeft") and can_shoot:
		can_shoot = false

		# Forward direction from muzzle to cursor
		var forward_dir = (get_global_mouse_position() - %FirePoint.global_position).normalized()

		# Spawn each pellet with a random angular offset inside the spread cone
		for i in bullet_count:
			var offset_angle = deg_to_rad(randf_range(-spread_degrees * 0.5, spread_degrees * 0.5))
			var dir = forward_dir.rotated(offset_angle)
			var pellet = bullet_ref.instantiate()
			pellet.velocity        = dir                        # your projectile script should multiply by .speed internally, or:
			pellet.speed           = speed                      # if it expects speed separately
			pellet.global_position = %FirePoint.global_position
			if "damage" in pellet:                              # only if your projectile exposes it
				pellet.damage = damage
			get_tree().root.add_child(pellet)
			Globals.CURRENT_AMMO[weapon_idx]-=1
			print("Current ammo: ", Globals.CURRENT_AMMO[weapon_idx])
		knockback((get_global_mouse_position() - %FirePoint.global_position).normalized())
		$Cooldown.start(shoot_cooldown / Upgrades.player_firerate_multiplier)
	if !is_left && check_can_shoot() && Input.is_action_pressed("ShootRight") and can_shoot:
		can_shoot = false

		# Forward direction from muzzle to cursor
		var forward_dir = (get_global_mouse_position() - %FirePoint.global_position).normalized()

		# Spawn each pellet with a random angular offset inside the spread cone
		for i in bullet_count:
			var offset_angle = deg_to_rad(randf_range(-spread_degrees * 0.5, spread_degrees * 0.5))
			var dir = forward_dir.rotated(offset_angle)
			var pellet = bullet_ref.instantiate()
			pellet.velocity        = dir                        # your projectile script should multiply by .speed internally, or:
			pellet.speed           = speed                      # if it expects speed separately
			pellet.global_position = %FirePoint.global_position
			if "damage" in pellet:                              # only if your projectile exposes it
				pellet.damage = damage
			get_tree().root.add_child(pellet)
			Globals.CURRENT_AMMO[weapon_idx]-=1
			print("Current ammo: ", Globals.CURRENT_AMMO[weapon_idx])
		knockback((get_global_mouse_position() - %FirePoint.global_position).normalized())
		$Cooldown.start(shoot_cooldown / Upgrades.player_firerate_multiplier)

	var to_mouse = get_global_mouse_position() - global_position
	global_rotation = rotate_toward(global_rotation, to_mouse.angle(), delta * gun_rotate_speed)
	$Sprite2D.flip_v = rad_to_deg(abs(global_rotation)) > 90
