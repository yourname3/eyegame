extends CollisionShape2D

var ParentArea2D : Area2D

func _ready() -> void:
	ParentArea2D = get_parent()
	
	
func _process(delta: float) -> void:
	for collider in ParentArea2D.get_overlapping_bodies():
		print("Detected Overlap")
		if collider.is_in_group("Enemies"):
			print("enemy detected destroying them")
			collider.queue_free()
			Globals.EYE_HEALTH -= 10
		
