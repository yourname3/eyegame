extends Node2D
class_name Gun

var can_shoot := false
var bullet_ref := preload("res://proto/proto_projectile.tscn")
var gun_rotate_speed := 10

@export var bullet_count = 1
@export var speed := 900
@export var shoot_cooldown := .5
@export var damage := 1
@export var weapon_idx: int = 0
@export var unequip = false
@export var is_left = false
# Called when the node enters the scene tree for the first time.

func _ready():
	pass
func check_remove_gun():
	if Globals.CURRENT_AMMO[weapon_idx] == 0:
		Globals.OWNED_WEAPONS[weapon_idx] = false
		print("disowned gun")
		
func knockback(shoot_dir):
	var force = 1
	if bullet_count:
		force *= bullet_count * damage
	else:
		force *=  damage
		
	#Get the direction we shot in
	get_parent().get_parent().weapon_knockback = -force*shoot_dir*100
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func check_can_shoot():
	if Globals.game_ui_ref:
		Globals.game_ui_ref.update_ammo_text()
	check_remove_gun()
	if !Globals.OWNED_WEAPONS[weapon_idx]:
		unequip = true
		print("MUST UNEQUIP")
	if Globals.CURRENT_AMMO[weapon_idx] < 1: return false
	else: return true
	
## May be overriden in child classes.
func _play_shoot_sfx() -> void:
	if weapon_idx == Globals.GUN_RPG || weapon_idx == Globals.GUN_GRAVITY:
		Sounds.sfx_grenade_launch.play()
	else:
		Sounds.sfx_bullet_shoot.play()
	
func _physics_process(delta):
	if check_can_shoot() && is_left && Input.is_action_pressed("ShootLeft") && can_shoot:
		can_shoot = false
		
		var bullet = bullet_ref.instantiate()
		bullet.velocity = (get_global_mouse_position() - %FirePoint.global_position).normalized() 
		bullet.global_position = %FirePoint.global_position
		bullet.speed = speed
		bullet.gun_id = weapon_idx
		
		knockback((get_global_mouse_position() - %FirePoint.global_position).normalized())
		get_tree().root.add_child(bullet)
		_play_shoot_sfx()
		$Cooldown.start(shoot_cooldown / Upgrades.player_firerate_multiplier)
		Globals.CURRENT_AMMO[weapon_idx]-=1
		print("Current ammo: ", Globals.CURRENT_AMMO[weapon_idx])
	elif check_can_shoot() && !is_left && Input.is_action_pressed("ShootRight") && can_shoot:
		can_shoot = false
		
		var bullet = bullet_ref.instantiate()
		bullet.velocity = (get_global_mouse_position() - %FirePoint.global_position).normalized() 
		bullet.global_position = %FirePoint.global_position
		bullet.speed = speed
		bullet.gun_id = weapon_idx
		
		knockback((get_global_mouse_position() - %FirePoint.global_position).normalized())
		get_tree().root.add_child(bullet)
		_play_shoot_sfx()
		$Cooldown.start(shoot_cooldown / Upgrades.player_firerate_multiplier)
		Globals.CURRENT_AMMO[weapon_idx]-=1
		print("Current ammo: ", Globals.CURRENT_AMMO[weapon_idx])
	#Rotate gun towards mouse as well
	var to_mouse = get_global_mouse_position() - global_position
	
	
	
	global_rotation = rotate_toward(global_rotation, to_mouse.angle(), delta * gun_rotate_speed)
	
	if rad_to_deg(abs(global_rotation)) > 90:
		$Sprite2D.flip_v = true
	else:
		$Sprite2D.flip_v = false

func _on_cooldown_timeout():
	can_shoot = true

func get_input() -> Vector2:
	return Input.get_vector("Aiming Left", "Aiming Right", "Aiming Up", "Aiming Down")

func _on_weapon_swap_cd_timeout() -> void:
	can_shoot = true
