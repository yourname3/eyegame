@tool
extends Node2D
class_name EyeballMaskChild

# In order to get the masking effect of the eyeball, we must scale it but
# ourselves maintain a scale of 1.0.
#
# So, do that inside this script, and do it as a tool too.

func _process(delta: float) -> void:
	global_scale = Vector2.ONE
