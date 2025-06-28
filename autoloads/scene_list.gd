extends Node
## So, usually in Godot, you can just do:
## var thing = preload("res://path/to/scene").instantiate() or
## SceneTransition.change_scene_to_packed(preload("res://path/to/scene")
##
## However, if you try to have two scenes that reference each other in a SceneTransition
## through a preload, it is a cyclic reference that Godot doesn't like, but you
## don't even get a real error message, only:
##
##     scene_transition.gd:28 @ _switch_now(): Failed to instantiate scene state of "", node count is 0. Make sure the PackedScene resource is valid.
##     
## Which doesn't make any sense.
##
## There are two ways around this.
## 1. Switch one of the preloads to a load(). This might generally be a good
##    idea -- if you are careful, you could have your MainMenu rely on almost
##    nothing and have the game boot fast, and then load() everything else
##    you need, hopefully with a nicely polished loading bar.
## 2. Place both of the preloads() you want in a single Autoload. This breaks
##    the cycle as the Autoload I guess doesn't count as a dependency or something?
##    Not sure why, but it kinda makes sense.
##
## Option 2 is what this script is for. It lets us say, inside main_menu.tscn,
## SceneTransition.change_scene_to_packed(SceneList.Game) and then inside
## pause_menu.tscn say change_scene_to_packed(SceneList.MainMenu).
##
## The bonus of using preloads like this is that once the game is past the
## initial splash screen, the entire game is loaded and works pretty fast from
## then on out.
##
## So basically, add any other relevant scenes to this gd file if you need
## to break more cycles. But it's also fine to just preload() a path directly
## when instantiating, etc.
class_name SceneListScript

var Game: PackedScene = preload("res://game.tscn")
var MainMenu: PackedScene = preload("res://menus/main_menu/main_menu.tscn")
