extends Node2D

var velocity = Vector2.ZERO
var speed := 0.0
var damage := 3
var gun_id: int = 0

@onready var rotator := $Rotator

func _physics_process(delta: float) -> void:
	position += velocity * delta * speed
	
	rotator.rotate(TAU * 4 * delta)


func _on_life_time_timeout():
	spawn_explosion()
	queue_free()

func spawn_explosion():
	var explosion = preload("res://player/weapons/projectiles/explosion.tscn")
	var e = explosion.instantiate()
	#e.global_position = global_position
	get_tree().root.add_child.call_deferred(e)
	get_node("root/Game").add_child.call_deferred(e)
	print("spawned e: ", e)
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Enemies"):
		spawn_explosion()
		#print(body.get_health())
		Globals.transmit_damage.emit(body, damage)
		queue_free()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("hello???, i am", area, " My group is: ", area.get_groups()_get_groups())
	if area.get_parent().is_in_group("Projectiles") and !area.get_parent().is_in_group("Explosives"):
		print("Rocket hits projectile")
		spawn_explosion()
		queue_free()


#var velocity = Vector2.ZERO
#var speed := 0.0
#var damage := 0.0
#func _physics_process(delta: float) -> void:
	#position += velocity * delta * speed
#
#
#func _on_life_time_timeout():
	#queue_free()
#
#
#func _on_area_2d_body_entered(body):
	#if body.is_in_group("Enemies"):
		#Globals.transmit_damage.emit(body, 1)
		#print(body.get_health())
		#queue_free()
		
