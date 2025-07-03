extends Control




func _on_back_to_menu_pressed() -> void:
	Sounds.sfx_item_select.play()
	SceneTransition.change_scene_to_packed(SceneList.MainMenu)# Replace with function body.
