extends Sprite2D

func _ready():
	hide()

func hide_indicator():
	hide()

func _on_two_way_detection_target_has_changed():
	get_tree().call_group("target_indicators", "hide_indicator")
	show()
	
