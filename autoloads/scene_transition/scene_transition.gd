extends CanvasLayer
# THIS IS AN AUTOLOAD.
# To use, write:
# SceneTransition.change_scene_to_packed(preload("res://game.tscn"))
#
# or similar.
class_name SceneTransitionScript

var _next_scene: PackedScene = null

func _ready() -> void:
	# Set ourselves to always so we can process when we are paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_scene_to_packed(scene: PackedScene, animation: StringName = "transition") -> void:
	# Don't let us change multiple scenes until we're done
	if _next_scene != null:
		return
		
	_next_scene = scene
	%AnimationPlayer.play("RESET")
	%AnimationPlayer.play(animation)
	
# Called by our AnimationPlayer when we're halfway through the anim.
func _switch_now() -> void:
	if _next_scene == null:
		push_error("Tried to change scenes when we didn't have one")
		return
	get_tree().change_scene_to_packed(_next_scene)
	_next_scene = null
	
	# Make sure to unpause the game now that we're in a new scene
	get_tree().paused = false
