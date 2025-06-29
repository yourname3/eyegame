extends Node2D

func _ready():
	$GPUParticles2D.restart()
	#$LifeTime.start(.8)ddddw
	Sounds.sfx_grenade_explosion.play()

	



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explode":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		Globals.transmit_damage.emit(body, 1 * Upgrades.player_damage_multiplier)
