extends Resource
## Represents a single upgrade. 
class_name Upgrade

@export var upgrades_var: StringName = ""

## Set this to -1 if this upgrade does not unlock a gun.
@export var gun_index: int = -1
## If this upgrade grants a gun, this controls how much ammo it
## grants.
@export var gun_ammo: int = 0

## The description of this upgrade. 
@export_multiline var description: String = ""

## Applies this upgrade. This should happen when we purchase it. This usually
## will either update gun ammo / inventory, or it will increase a counter inside
## Upgrades based on ugprades_var. This lets us access that information throughout
## the game.
func apply() -> void:
	if upgrades_var != "":
		# Increment the variable if it exists. We don't care that this is likely
		# slow, as we are only doing this once each time we buy an upgrade.
		var prev_val = Upgrades.get(upgrades_var)
		if typeof(prev_val) == TYPE_INT:	
			Upgrades.set(upgrades_var, prev_val + 1)
		else:
			push_error("upgrade.gd: Tried to apply an invalid ugprades_var: ", upgrades_var)

	if gun_index >= 0:
		Globals.unlock_gun(gun_index, gun_ammo)
