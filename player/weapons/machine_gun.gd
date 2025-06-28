extends Gun

#func _ready():
	
func _physics_process(delta):
	# call base class for rotation and shooting check
	super._physics_process(delta)

	# optionally change bullet_ref for this gun
