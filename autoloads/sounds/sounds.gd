extends Node
## Autoload Sounds. Lets you play various sound effects and music.
class_name TheSoundsScript

const MUSIC_GAME := 0
const MUSIC_MENU := 1

var current_music := -1

@onready var music: Array[AudioStreamPlayer] = [
	$Music_Game, $MusicMenu
]

@onready var sfx_blink := $Blink
@onready var sfx_blink_open := $BlinkOpen
@onready var sfx_blink_warning := $BlinkWarning
@onready var sfx_boss_death := $BossDeath
@onready var sfx_bullet_shoot := $BulletShootV3
@onready var sfx_enemy_death := $EnemyDeath
@onready var sfx_enemy_hit := $EnemyHit
@onready var sfx_grenade_explosion := $GrenadeExplosion
@onready var sfx_grenade_launch := $GrenadeLaunch
@onready var sfx_item_select := $ItemSelect
@onready var sfx_menu_hover := $MenuHover
@onready var sfx_player_hit := $PlayerHit
@onready var sfx_shotgun := $Shotgun

func play_music(idx: int) -> void:
	if idx < 0 or idx >= music.size():
		push_warning("Invalid music index")
		return

	if current_music != idx:
		# Restart music from beginning
		music[current_music].play()
	current_music = idx
	
func _physics_process(delta: float) -> void:
	for i in range(0, music.size()):
		var target_volume = 1.0 if i == current_music else 0.0
		music[i].volume_linear += (target_volume - music[i].volume_linear) * 0.04
		


func _on_blink_finished() -> void:
	sfx_blink_open.play()


func _on_boss_death_finished() -> void:
	get_tree().change_scene_to_file("res://game_over_screen.tscn")
