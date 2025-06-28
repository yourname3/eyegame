extends Node2D
var player
var fly : bool = false
func _ready() -> void:
	player = get_tree().get_first_node_in_group("Players")
	if !player:
		print("ERROR: Player not found on EXP orb")
	
func _physics_process(delta: float) -> void:
	print(player)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		print("near player")
		fly = true
