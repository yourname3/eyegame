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

func _reset():
	shoot_enemy_with_pistol_gain_ammo = 0
	kill_enemy_gives_double_damage = 0
	take_damage_gives_fire_rate = 0
	kill_5_gives_heal_5 = 0
	rolls_for_extra_xp = 0

	enemy_wave_spawn_extra_first = 0
	enemy_damage_boosts = 0
	enemy_speed_boosts = 0
	enemy_health_boosts = 0
	enemy_small_boosts = 0
	enemy_spawn_rolls = 0
	
	_double_damage_timer = 0
	_double_firerate_timer = 0
	_heal_five_counter = 0

# -- Below is variables used for tracking stuff relevant to particular
# -- upgrades. This is done by the Upgrades script so that the relevant
# -- code in other scritps can be as simple as possible.

var player_damage_multiplier := 1.0
var player_firerate_multiplier := 1.0

var enemy_damage_multiplier := 1.0
var enemy_speed_multiplier  := 1.0
var enemy_health_multiplier := 1.0
var enemy_scale_multiplier  := 1.0

var _double_damage_timer := 0.0
var _double_firerate_timer := 0.0
var _heal_five_counter: int = 0

func _ready() -> void:
	SignalBus.enemy_died.connect(func():
		# This upgrade resets this timer -- you do get an additional 0.25 per
		# copy of the upgrade.
		_double_damage_timer = 0.75 * kill_enemy_gives_double_damage
	
		if kill_5_gives_heal_5 > 0:	
			_heal_five_counter += 1
			var player: Player = get_tree().get_first_node_in_group("Players")
			if player != null:
				while _heal_five_counter >= 5:
					player._set_health(player.health + 5 * kill_5_gives_heal_5)
					_heal_five_counter -= 5
	)
	
	SignalBus.player_damaged.connect(func():
		_double_firerate_timer = 2.0 * take_damage_gives_fire_rate
	)

func _process(delta: float) -> void:
	if _double_damage_timer >= 0.0:
		_double_damage_timer -= delta
	if _double_firerate_timer >= 0.0:
		_double_firerate_timer -= delta
	
	player_damage_multiplier = 2.0 if _double_damage_timer > 0.0 else 1.0
	player_firerate_multiplier = 2.0 if _double_firerate_timer > 0.0 else 1.0

	enemy_damage_multiplier = 1.0 + enemy_damage_boosts * 0.1#= pow(1.1, enemy_damage_boosts)
	enemy_speed_multiplier  = 1.0 + enemy_speed_boosts * 0.02#= pow(1.1, enemy_speed_boosts)
	enemy_health_multiplier = 1.0 + enemy_health_boosts * 0.1#= pow(1.1, enemy_health_boosts)
	enemy_scale_multiplier  = pow(0.9, enemy_small_boosts)
