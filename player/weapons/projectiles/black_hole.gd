extends Node2D


var velocity = Vector2.ZERO
var speed := 0.0
var damage := 1
var braking_force = 0.99

func _physics_process(delta: float) -> void:
	position += velocity * delta * speed
	velocity *= braking_force

func _on_life_time_timeout():
	#spawn_explosion()
	queue_free()
#
#func spawn_explosion():
	#var explosion = preload("res://player/weapons/projectiles/explosion.tscn")
	#var e = explosion.instantiate()
	#e.global_position = global_position
	#get_tree().root.add_child.call_deferred(e)
	#print("spawned e: ", e)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explode":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("do stuff on blackhole enemy")
		#Globals.transmit_damage.emit(body, 1)
