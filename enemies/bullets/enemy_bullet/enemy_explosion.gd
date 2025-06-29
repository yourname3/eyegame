extends Node2D
class_name EnemyExplosion

#func _ready():
	#$LifeTime.start(.8)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explode":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		Globals.transmit_damage.emit(body, 3)
