extends Sprite2D

func _ready():
	hide()

func hide_indicator():
	hide()

func _on_two_way_detection_target_has_changed(_area : Area2D):
	get_tree().call_group("target_indicators", "hide_indicator")
	show()
	
