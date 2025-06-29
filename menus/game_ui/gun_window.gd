extends Panel

var weapon_idx = 0

func set_ammo_text():
	$Label3.text = str(Globals.CURRENT_AMMO[weapon_idx] , " / " , Globals.MAX_AMMO[weapon_idx])
