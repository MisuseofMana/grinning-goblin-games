extends NinePatchRect

@onready var dot_container = $MarginContainer/HBoxContainer/DotContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	dot_container.get_child(0).self_modulate = Color(0,1,0)
	
