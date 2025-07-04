extends CanvasLayer
class_name PauseMenu

@onready var menu = %Menu
var tween: Tween = null

func _kill_tween() -> Tween:
	if tween != null:
		tween.kill()
		tween = null
	return create_tween()

func unpause() -> void:
	if not get_tree().paused:
		return
	Globals.pop_pause()
	
	tween = _kill_tween()
	tween.tween_property(menu, "anchor_top", 1.0, 0.3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "visible", false, 0.0)
	
func pause() -> void:
	if visible:
		return
	Globals.push_pause()
	
	show()
	tween = _kill_tween()
	tween.tween_property(menu, "anchor_top", 0.0, 0.3).set_ease(Tween.EASE_IN_OUT)

func toggle_pause() -> void:
	if visible:
		unpause()
	else:
		pause()

func _ready() -> void:
	# Always process, even when the game is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	%ResumeButton.pressed.connect(unpause)
	%QuitButton.pressed.connect(func():
		# Need to use 'load' to fix the cyclic reference. (???)
		SceneTransition.change_scene_to_packed(load("res://menus/main_menu/main_menu.tscn"))
	)
	# Hide menu through same property as animations
	menu.anchor_top = 1.0
	hide()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
