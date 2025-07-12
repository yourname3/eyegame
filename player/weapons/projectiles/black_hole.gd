extends Node2D


var velocity = Vector2.ZERO
var speed := 0.0
var damage := 1
var braking_force = 0.99
var victims:= []
@export var pull_force:= 10
var gun_id := 0

func _ready():
	$AnimationPlayer.speed_scale = .667
func _physics_process(delta: float) -> void:
	position += velocity * delta * speed
	velocity *= braking_force
	for i in victims:
		if is_instance_valid(i):
			i.velocity += (global_position - i.global_position).normalized() * pull_force
func _on_life_time_timeout():
	#spawn_explosion()
	queue_free()
#
#func spawn_explosion():
	#var explosion = preload("res://player/weapons/projectiles/explosion.tscn")
	#var e = explosion.instantiate()
	#e.global_position = global_position
	#get_tree().Game.add_child.call_deferred(e)
	#print("spawned e: ", e)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Explode":
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("do stuff on blackhole enemy")
		#Globals.transmit_damage.emit(body, 1)



func _on_scan_area_timeout() -> void:
	var valid_victims = $Area2D.get_overlapping_bodies()
	print("Valid victims: ", valid_victims)
	var idx = 0
	for i in range(valid_victims.size()):
		if !valid_victims[idx].is_in_group("Enemies"):
			valid_victims.remove_at(idx)
			
	victims = valid_victims
	print("Victims: ", victims)
