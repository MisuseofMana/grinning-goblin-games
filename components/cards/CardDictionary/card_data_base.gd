extends Resource
class_name CardData

@export var card_name : String = ''
@export var card_description : String = ''
@export var card_image : Texture
@export var card_effect_value : int = 0

@export_enum('self', 'enemy') var valid_target : String

func cardEffect():
	pass
