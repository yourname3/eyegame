extends Control
## The central controller for the actual upgrading action.
##
## Manages showing upgrades to the player, and applying the selected
## upgrade (through Upgrade.apply())
##
## Contains the entire list of player and enemy ugprades. If you add more
## upgrades, be sure to add them in the array in upgrade_menu.tscn
class_name UpgradeMenu

@onready var panels := [
	%UpgradePanel,
	%UpgradePanel2,
	%UpgradePanel3,
]

@export var player_upgrades: Array[Upgrade] = []
@export var enemy_upgrades: Array[Upgrade] = []
