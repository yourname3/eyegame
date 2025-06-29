extends Node2D

@export var enemy_data: Array[Wave]

@export var current_wave: int

@export var SpawnPoints: Array[Node2D]

@export var SpawningRoot: Node2D

func _ready() -> void:
	print("thing is loaded")
	
	for i in enemy_data.size():
		#print(enemy_data[i])
		var newWave = enemy_data[i]
		for j in newWave.enemy_sequences:
			print(j)
			print(j.Enemy)
			print(j.EnemyAmount)
			print(j.EnemySpawnInterval)
			
	
	$Wave_Timer.wait_time = enemy_data[current_wave].SecondsTillNextWave
	
	print(enemy_data[current_wave].SecondsTillNextWave)
	
	$Wave_Timer.start()
	
	$Wave_Timer.timeout.connect(_NextWave)

	

func _process(delta: float) -> void:
	pass
	
			
			# array - list each wave of enemies coming in 


func _NextWave() -> void:
	
	print("timer over")
	current_wave += 1
	
	print(current_wave)	
	
	var array_size = enemy_data.size()
	
	if  current_wave <= array_size-1:
		print(enemy_data[current_wave].SecondsTillNextWave)
		
		var newWave = enemy_data[current_wave]
		for j in newWave.enemy_sequences:
			print(j)
			print(j.Enemy)
			print(j.EnemyAmount)
			print(j.EnemySpawnInterval)
			#this is the part where we spawn in the stuff
			
			for i in j.EnemyAmount:
				await get_tree().create_timer(j.EnemySpawnInterval).timeout
				#pick a random spawn point 
				
				var spawnPoint = SpawnPoints.pick_random()
				
				#spawm enemy at that point
				var newEnemy = j.Enemy.instantiate()
				SpawningRoot.add_child(newEnemy)
				
				
			
		
		
		$Wave_Timer.wait_time = enemy_data[current_wave].SecondsTillNextWave
		$Wave_Timer.start()
	else:
		print("All Waves Over") 
	 
	
	
# wave
# time till next wave
# enemy dictionary 
		#type , number 
		
#if all enemies in wave are all defeated then next wave is triggered early 

#if next wave timer reaches zero next wave is also triggered 

#function to trigger a wave
