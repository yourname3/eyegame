extends Control
class_name MainMenu

var _credits_tween: Tween = null

@onready var credits = %Credits

func _recreate_tween() -> void:
	if _credits_tween != null:
		_credits_tween.kill()
		_credits_tween = null
	_credits_tween = create_tween()

func open_credits() -> void:
	_recreate_tween()
	credits.show()
	_credits_tween.tween_property(credits, "anchor_top", 0.0, 0.3)
	_credits_tween.tween_property(%CloseCreditsButton, "visible", true, 0.0)

func close_credits() -> void:
	_recreate_tween()
	%CloseCreditsButton.hide()
	_credits_tween.tween_property(credits, "anchor_top", 1.0, 0.3)
	_credits_tween.tween_property(credits, "visible", false, 0.0)

func _ready() -> void:
	credits.hide()
	credits.anchor_top = 1.0
	$%CloseCreditsButton.hide()
	
	%PlayButton.pressed.connect(func():
		SceneTransition.change_scene_to_packed(SceneList.Game)
	)
	
	%PlayButton.grab_focus()
	
	%OpenCreditsButton.pressed.connect(open_credits)
	%CloseCreditsButton.pressed.connect(close_credits)
