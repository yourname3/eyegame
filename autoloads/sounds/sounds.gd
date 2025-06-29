extends Node
## Autoload Sounds. Lets you play various sound effects and music.
class_name TheSoundsScript

const MUSIC_GAME := 0
const MUSIC_MENU := 1

var current_music := -1

@onready var music: Array[AudioStreamPlayer] = [
	$Music_Game
]

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
		
