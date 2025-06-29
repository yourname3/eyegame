extends Node
## Access through SignalBus autoload.
##
## Global signals, useful for things like indicating "an enemy died"
## and similar.
class_name TheSignalBusScript

## Emitted when any enemy dies.
signal enemy_died()

## Emitted when the player takes damage.
signal player_damaged()
