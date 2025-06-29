extends Node2D
class_name Game


@export var player : Player

@export var nav_region : NavigationRegion2D


var rand_point
var eye_speed = 100
func _ready() -> void:
	Globals.nav_rid = nav_region.get_rid()
	Globals.player = player
	Globals.game_ui_ref = $GameUI/GameUI
	
	Sounds.play_music(Sounds.MUSIC_GAME)

func _physics_process(delta: float) -> void:
	if rand_point:
		$EyeIrisPupil.global_position = $EyeIrisPupil.global_position.move_toward(rand_point, delta * eye_speed)

func _on_choose_iris_move_timeout() -> void:
	var rect : Rect2 = $ChooseIrisMove/Area2D/CollisionShape2D.shape.get_rect()
	var x = randi_range(rect.position.x, rect.position.x + rect.size.x)
	var y = randi_range(rect.position.y, rect.position.y + rect.size.y)
	var r = global_position + Vector2(x, y)
	print(r)
	rand_point = r
	
