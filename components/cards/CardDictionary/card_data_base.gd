extends Resource
class_name CardData

@export var card_name : String = ''
@export var card_description : String = ''
@export var card_image : Texture

var successfulDrag = false

func completeDrag():
	successfulDrag = true
