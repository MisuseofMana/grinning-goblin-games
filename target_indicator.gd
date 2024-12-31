extends Sprite2D

func _ready():
	hide()

func _on_two_way_detection_target_has_changed(currentTarget: Variant) -> void:
	if currentTarget == owner:
		show()
	else:
		hide()
