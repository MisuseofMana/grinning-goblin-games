extends Node2D

@onready var label = $Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = str(get_global_mouse_position())
