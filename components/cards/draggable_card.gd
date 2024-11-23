extends TextureRect

@onready var card_base = $"."
@onready var draggable_card = $DraggableCard
@onready var card_image = $DraggableCard/CardImageSlot
@onready var card_description = $"DraggableCard/Card Description"
@onready var card_name = $"DraggableCard/Card Name"
@onready var pickup_sound = $MouseOverSound

@export var card_type : CardData

const SPEED := 0.2

func _ready():
	if(card_type):
		card_name.text = card_type.card_name
		card_description = card_type.card_description
		card_image.texture = card_type.card_image
	else: 
		card_name.text = 'Missing Data'
		card_description = ''
		card_image.texture = null

func _on_mouse_entered():
	pickup_sound.play()
	card_base.z_index = 100
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.4, 1.4), SPEED)

func _on_mouse_exited():
	card_base.z_index = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), SPEED)
