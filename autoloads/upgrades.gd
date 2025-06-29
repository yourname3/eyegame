extends Node
## Access this through the autolaod Upgrades.
##
## This gives you access to the count of each upgrade we have purchased, where
## relevant. For example, the upgrade that lets you gain ammo when you shoot
## enemies with your pistol, is counted in "shoot_enemy_with_pistol_gain_ammo."
##
## The values in here are incremented by individual Upgrade resources, when they
## have the upgrades_var string set to a non-empty value. (Set it to "" to 
## NOT increase any counter here).
class_name TheUpgradesScript

# Properties for the player-related upgrades
var shoot_enemy_with_pistol_gain_ammo: int = 0
var kill_enemy_gives_double_damage: int = 0
var take_damage_gives_fire_rate: int = 0
var kill_5_gives_heal_5: int = 0
var rolls_for_extra_xp: int = 0

# Properties for the enemy-related upgrades
## Times the enemy wave spawns copies of the first enemy.
## NOTE: This might get multiplied by 2 or something
## in the wave script.
var enemy_wave_spawn_extra_first: int = 0
var enemy_damage_boosts: int = 0
var enemy_speed_boosts: int = 0
var enemy_health_boosts: int = 0
## The enemy gets smaller based on this upgrade
var enemy_small_boosts: int = 0
## How many times the enemies roll for spawning themselves on death
var enemy_spawn_rolls: int = 0
