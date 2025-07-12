extends CanvasLayer

var explosion = preload("res://player/weapons/projectiles/explosion.tscn")
var RPG = preload("res://player/weapons/projectiles/rpg_bullet.tscn")
var black_hole = preload("res://player/weapons/projectiles/black_hole.tscn")


func _process(delta: float) -> void:
	Sounds._cut_grenade_sound()
	#if $ProgressBar.value == $ProgressBar.max_value:
		#Globals.reset_game_state()
		#SceneTransition.change_scene_to_packed(load("res://game.tscn"))


func _on_timer_timeout() -> void:
		var children = self.get_children()
		for i in children:
			i.queue_free()
			print("deleted obj " , i.name)
		Globals.reset_game_state()
		SceneTransition.change_scene_to_packed(load("res://game.tscn"))


func _on_spawn_shaders_timeout() -> void:
	self.add_child(explosion.instantiate())
	self.add_child(RPG.instantiate())
	self.add_child(black_hole.instantiate())
