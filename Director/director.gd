extends Node2D

@export var player : Player

@export var enemy_data: Array[Wave]

@export var current_wave: int

@export var SpawnPoints: Array[Node2D]

@export var SpawningRoot: Node2D

@export var BlinkingAnimator: AnimationPlayer

var outstanding_sequences: int = 0

signal _ready_for_next_wave

func _do_sequence(sequence: EnemySequence) -> void:
	outstanding_sequences += 1
	for i in sequence.EnemyAmount:
		await get_tree().create_timer(sequence.EnemySpawnInterval).timeout
		#pick a random spawn point 
		
		var spawnPoint = SpawnPoints.pick_random()
		
		#spawm enemy at that point
		var newEnemy = sequence.Enemy.instantiate()
		newEnemy.sensory.target = player
		SpawningRoot.add_child(newEnemy)
		
	# If we were the last sequence, signal to the wave manager that we're
	# ready for the next wave
	outstanding_sequences -= 1
	if outstanding_sequences <= 0:
		_ready_for_next_wave.emit()
	
func _ready() -> void:
	print("thing is loaded")
	
	for wave in enemy_data:
		await get_tree().create_timer(wave.SecondsTillNextWave).timeout
		
		# Spawn coroutine for each spawner
		for sequence in wave.enemy_sequences:
			_do_sequence(sequence)
		
		await _ready_for_next_wave


func _play_blink() -> void:
	BlinkingAnimator.play("Blink")
	
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		_play_blink()
# wave
# time till next wave
# enemy dictionary 
		#type , number 
		
#if all enemies in wave are all defeated then next wave is triggered early 

#if next wave timer reaches zero next wave is also triggered 

#function to trigger a wave
