extends Node2D

@export var player : Player

@export var enemy_data: Array[Wave]

@export var current_wave: int

@export var EnemyPathfindingArea: NavigationRegion2D

@export var PupilZone : Area2D

@export var PupilcollsionShape : CollisionShape2D

@export var SpawningRoot: Node2D

@export var BlinkingAnimator: AnimationPlayer

@export var BlinkTimer : Timer 

var outstanding_sequences: int = 0

signal _ready_for_next_wave

func _pick_random_point() -> Vector2:
	var point = NavigationServer2D.region_get_random_point(Globals.nav_rid, 0, true)
	var fuel = 5000
	while point.distance_to(PupilZone.global_position) < PupilcollsionShape.shape.radius:
		point = NavigationServer2D.region_get_random_point(Globals.nav_rid, 0, true)
		fuel -= 1
		if fuel <= 0:
			break
	return point

func _do_sequence(sequence: EnemySequence) -> void:
	outstanding_sequences += 1
	for i in sequence.EnemyAmount:
		await get_tree().create_timer(sequence.EnemySpawnInterval, false).timeout
		#pick a random spawn point within navigation region
		
		#make sure its not too close to the player 
		
		#spawn the enemy there 
		
		#spawm enemy at that point
		var newEnemy = sequence.Enemy.instantiate()
		newEnemy.global_position = _pick_random_point()
		print("newEnemy target = ", player)
				
		newEnemy.sensory.target = player
		SpawningRoot.add_child(newEnemy)
		
	# If we were the last sequence, signal to the wave manager that we're
	# ready for the next wave
	outstanding_sequences -= 1
	if outstanding_sequences <= 0:
		_ready_for_next_wave.emit()
	
func _ready() -> void:
	print("thing is loaded")
	
	BlinkTimer.start(randf_range(5.0, 15.0))
	BlinkTimer.timeout.connect(_play_blink)
	
	for wave in enemy_data:
		await get_tree().create_timer(wave.SecondsTillNextWave, false).timeout
		
		# Spawn coroutine for each spawner
		for sequence in wave.enemy_sequences:
			_do_sequence(sequence)
		
		await _ready_for_next_wave


func _play_blink() -> void:
	BlinkingAnimator.play("Blink")
	BlinkTimer.start(randf_range(5.0, 15.0))
	Sounds.sfx_blink_open.play()
	
	
	
func _process(delta: float) -> void:
	if BlinkTimer.time_left <= 2.0 and !Sounds.sfx_blink_warning.is_playing():
		Sounds.sfx_blink_warning.play()
	if Globals.EYE_HEALTH <= 0:
		get_tree().change_scene_to_file("res://game_over_screen.tscn")
		
	
	#if Input.is_key_pressed(KEY_SPACE):		
		#_play_blink()
		
# wave


func _teleport_all_enemies() -> void:
	#get list of all enemies 
	var nodes_in_group = get_tree().get_nodes_in_group("Enemies")
	
	for i in nodes_in_group:
		i.global_position = _pick_random_point()

		
	
	#loop list
		#find random spot in eye
		#check spot is valid
		#teleport enemy there
	
# time till next wave
# enemy dictionary 
		#type , number 
		
#if all enemies in wave are all defeated then next wave is triggered early 

#if next wave timer reaches zero next wave is also triggered 

#function to trigger a wave
