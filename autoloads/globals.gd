extends Node

var player = CharacterBody2D
#0 - pistol 
#1 - rifle
#2 - shotgun
#3 - RPG
#4 - Gravity Gun
#5 - Delayed Bombs
var MAX_AMMO = [
	9999999999999,
	175,
	180,
	7,
	4,
	20,
]

var CURRENT_AMMO = MAX_AMMO
var OWNED_WEAPONS = [true, true, true, true, true]
signal transmit_damage(body, amount)


var EYE_HEALTH : float = 100


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





var nav_rid
var center_point : Vector2 = Vector2(2448.0, 434.0)



func _ready() -> void:
	transmit_damage.connect(receive_damage)


func receive_damage(target, damage:int):
	target._set_health(target.get_health() - damage)
