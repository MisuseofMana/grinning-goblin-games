extends Area2D

@onready var hand: Area2D = $"."
@onready var h_box_container: HBoxContainer = $"../BoxContainer/HBoxContainer"

func _on_area_entered(area: Area2D) -> void:
	print(area)
	
