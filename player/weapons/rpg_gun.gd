extends Gun

@export var black_hole: bool = false
func _ready():
	if black_hole:
		bullet_ref = preload("res://player/weapons/projectiles/black_hole.tscn")
	else:
		bullet_ref = preload("res://player/weapons/projectiles/rpg_bullet.tscn")
