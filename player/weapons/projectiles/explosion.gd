extends Node2D
@export var explosion_damage: float
func _ready():
	$GPUParticles2D.restart()
	#$LifeTime.start(.8)ddddw
	Sounds.sfx_grenade_explosion.play()

	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		Globals.transmit_damage.emit(body, explosion_damage * Upgrades.player_damage_multiplier)


func _on_lifetime_timeout() -> void:
	queue_free()#ace with function body.
