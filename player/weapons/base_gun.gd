extends Node2D
class_name Gun

var can_shoot := true
var bullet_ref := preload("res://proto/proto_projectile.tscn")
var gun_rotate_speed := 10

@export var bullet_count = 1
@export var speed := 900
@export var shoot_cooldown := .5
@export var damage := 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func knockback(shoot_dir):
	var force = 1
	if bullet_count:
		force *= bullet_count * damage
	else:
		force *=  damage
		
	#Get the direction we shot in
	get_parent().get_parent().weapon_knockback = -force*shoot_dir*100
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("Shoot") && can_shoot:
		can_shoot = false
		
		var bullet = bullet_ref.instantiate()
		bullet.velocity = (get_global_mouse_position() - %FirePoint.global_position).normalized() 
		bullet.global_position = %FirePoint.global_position
		bullet.speed = speed
		
		knockback((get_global_mouse_position() - %FirePoint.global_position).normalized())
		get_tree().root.add_child(bullet)
		
		#print("spawned bullet, ", bullet)
		$Cooldown.start(shoot_cooldown)
	
	#Rotate gun towards mouse as well
	var to_mouse = get_global_mouse_position() - global_position
	global_rotation = rotate_toward(global_rotation, to_mouse.angle(), delta * gun_rotate_speed)
	

	if rad_to_deg(abs(global_rotation)) > 90:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false

func _on_cooldown_timeout():
	can_shoot = true
