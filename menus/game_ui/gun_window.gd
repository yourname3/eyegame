extends Control

var weapon_idx = 0
var selected = false
var selected_size = Vector2(1.5,1)
var default_size = Vector2(1,1)
var is_right = false
func set_ammo_text():
	if weapon_idx != 0:
		$AspectRatioContainer/Panel/Label3.text = str(Globals.CURRENT_AMMO[weapon_idx] , " / " , Globals.MAX_AMMO[weapon_idx])
	else:
		$AspectRatioContainer/Panel/Label3.text = "∞ / ∞"
	if selected:
		$AspectRatioContainer/Panel.size = selected_size * 100
		if is_right:
			position.x = -50
	else:
		$AspectRatioContainer/Panel.size = default_size * 100
		if is_right:
			position.x = 0
	
