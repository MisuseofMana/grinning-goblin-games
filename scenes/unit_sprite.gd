@icon("res://icons/UnitSprite.svg")
extends AnimatedSprite2D
class_name UnitSprite

@export var anims : AnimationPlayer

func _on_health_node_died():
	print('you died')
	pass # Replace with function body.
