extends Control




func _on_back_to_menu_pressed() -> void:
	Sounds.sfx_item_select.play()
	get_tree().change_scene_to_file("res://menus/main_menu/main_menu.tscn") # Replace with function body.
