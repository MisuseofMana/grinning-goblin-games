extends Control

@onready var texture_rect = $TextureRect

func _on_button_pressed():
	if texture_rect.visible:
		texture_rect.hide()
	else:
		texture_rect.show()
