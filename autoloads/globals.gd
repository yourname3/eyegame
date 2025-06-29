extends Node

var player : Player 
const GUN_PISTOL  := 0
const GUN_RIFLE   := 1
const GUN_SHOTGUN := 2
const GUN_RPG     := 3
const GUN_GRAVITY := 4

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


var nav_rid
var center_point : Vector2 = Vector2(2448.0, 434.0)

var EYE_HEALTH : float = 255
func _ready() -> void:
	transmit_damage.connect(receive_damage)


func receive_damage(target, damage:int):
	target._set_health(target.get_health() - damage)
