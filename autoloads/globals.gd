extends Node

var player : Player 
const GUN_PISTOL  := 0
const GUN_RIFLE   := 1
const GUN_SHOTGUN := 2
const GUN_RPG     := 3
const GUN_GRAVITY := 4

var equipped_left: int = 0
var equipped_right: int = 0

var pause_stack: int = 0

func push_pause() -> void:
	pause_stack += 1
	if pause_stack > 0:
		get_tree().paused = true
		
func pop_pause() -> void:
	pause_stack -= 1
	if pause_stack < 0:
		pause_stack = 0
	if pause_stack == 0:
		get_tree().paused = false
		
func gun_name(weapon_idx: int) -> String:
	match weapon_idx:
		0: return "Blaster"
		1: return "Rifle"
		2: return "Shotgun"
		3: return "RPG"
		4: return "Gravity Gun"
		_: return "Unknown"

func gun_texture(weapon_idx: int) -> Texture:
	match weapon_idx:
		0: return preload("res://player/blaster.svg")
		1: return preload("res://player/rifle.svg")
		2: return preload("res://player/shotgun.svg")
		3: return preload("res://player/rpg.svg")
		4: return preload("res://player/blackhole.svg")
		_: return null

#0 - pistol 
#1 - rifle
#2 - shotgun
#3 - RPG
#4 - Gravity Gun
##5 - Delayed Bombs
const MAX_AMMO_INIT: Array[int] = [
	9999999999999,
	175,
	180,
	80,
	4,
	20,
]

var MAX_AMMO: Array[int] = MAX_AMMO_INIT.duplicate()
var CURRENT_AMMO: Array[int] = MAX_AMMO.duplicate()
var OWNED_WEAPONS = [true, true, true, true, true]

## Stores the indices of each non-pistol weapon that we own.
var owned_nonpistol_weapons_by_idx: Array[int] = []

signal transmit_damage(body, amount)

## Call this when we start a new game. Should reset all global state to what
## it should be.
func reset_game_state() -> void:
	MAX_AMMO = MAX_AMMO_INIT.duplicate()
	for i in range(0, CURRENT_AMMO.size()):
		CURRENT_AMMO[i] = 0
	# Make sure we start out with max ammo for gun 0 (the pistol)
	CURRENT_AMMO[0] = MAX_AMMO[0]
	for i in range(0, OWNED_WEAPONS.size()):
		OWNED_WEAPONS[i] = false
	# We always have the pistol unlocked
	OWNED_WEAPONS[GUN_PISTOL] = true
	owned_nonpistol_weapons_by_idx = []

func unlock_gun(idx: int, ammo: int) -> void:
	OWNED_WEAPONS[idx] = true
	game_ui_ref.create_ui()
	CURRENT_AMMO[idx] += ammo
	if CURRENT_AMMO[idx] > MAX_AMMO[idx]:
		CURRENT_AMMO[idx] = MAX_AMMO[idx]
	
	if idx not in owned_nonpistol_weapons_by_idx:
		owned_nonpistol_weapons_by_idx.append(idx)
		
func add_ammo(weapon: int, amount: int) -> void:
	CURRENT_AMMO[weapon] += amount
	if CURRENT_AMMO[weapon] > MAX_AMMO[weapon]:
		CURRENT_AMMO[weapon] = MAX_AMMO[weapon]

enum Status {
	SUCCESS,
	RUNNING,
	FAILURE
}

enum NetStatus {
	README, # do not call
	SUCCESS, # keep the same
	RUNNING, # change 
	FAILURE, # code fails to run
	ERROR # error code
}



var enemy_bullet : PackedScene = preload("res://enemies/bullets/enemy_bullet/bullet.tscn")
var heavy_bullet : PackedScene = preload("res://enemies/bullets/enemy_bullet/heavy_bullet.tscn")
var curly_bullet : PackedScene = preload("res://enemies/bullets/enemy_bullet/curly_bullet.tscn")
var homing_bullet : PackedScene = preload("res://enemies/bullets/enemy_bullet/homing_bullet.tscn")
var explosive_bullet : PackedScene = preload("res://enemies/bullets/enemy_bullet/explosive_bullet.tscn")
var explosion : PackedScene = preload("res://enemies/bullets/enemy_bullet/enemy_explosion.tscn")


var game_ui_ref: GameUI


var CURRENT_WAVE : int = 1

var MAX_WAVES : int = 0

var nav_rid
var center_point : Vector2 = Vector2(2448.0, 434.0)

var MAX_EYE_HEALTH : float = 100
var EYE_HEALTH : float = 100
func _ready() -> void:
	transmit_damage.connect(receive_damage)


func receive_damage(target, damage:int):
	target._set_health(target.get_health() - damage)
