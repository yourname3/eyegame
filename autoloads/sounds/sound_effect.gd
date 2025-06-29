extends AudioStreamPlayer
## Wraps our sound in a SoundEffectRandomizer.
class_name SoundEffect

func _ready() -> void:
	var sound = stream
	var randomizer = AudioStreamRandomizer.new()
	randomizer.add_stream(0, sound)
	randomizer.random_pitch = 1.05
	randomizer.random_volume_offset_db = 2
	stream = randomizer
