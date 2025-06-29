extends Node2D
class_name ProtoProjectile
var velocity = Vector2.ZERO
var speed := 0.0
var damage := 0.0
## If we were fired from a gun, this stores the gun index.
var gun_id: int = -1

## How many more hits this projectile is allowed to do. Once it runs out of hits,
## it automatically despawns.
var remaining_hits = 1

func _physics_process(delta: float) -> void:
	position += velocity * delta * speed

func _on_life_time_timeout():
	queue_free()
	
func _hit_enemy() -> void:
	if gun_id == 0:
		if Globals.owned_nonpistol_weapons_by_idx.is_empty():
			return
		# Get a random ammo for this each time.
		for i in range(0, Upgrades.shoot_enemy_with_pistol_gain_ammo):
			var weapon = Globals.owned_nonpistol_weapons_by_idx.pick_random()
			Globals.add_ammo(weapon, 1)

func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemies"):
		if remaining_hits > 0:
			# TODO: Is 1 supposed to be 'damage'?
			Globals.transmit_damage.emit(body, 1 * Upgrades.player_damage_multiplier)
			print(body.get_health())
			remaining_hits -= 1
			
			_hit_enemy()
			
			if remaining_hits <= 0:
				queue_free()
		

#
