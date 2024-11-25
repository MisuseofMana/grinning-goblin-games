extends TextureRect

@onready var card_base = $"."
@onready var card_image = $CardImageSlot
@onready var card_description = $CardDescription
@onready var card_name = $CardName

@onready var pickup_sound = $MouseOverSound

@export var card_type : CardData

var is_dragging = false
var dragging_from_spot
const SPEED := 0.2
const delay := 4

func _ready():
	if(card_type):
		card_name.text = card_type.card_name
		card_description.text = card_type.card_description
		card_image.texture = card_type.card_image
	else: 
		card_name.text = 'Missing Data'
		card_description = ''
		card_image.texture = null

func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position() - Vector2(280, 380), delay * delta)
	
#replace with it's 2d counterpart
#make draggable
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
		else:
			is_dragging = false

func _on_mouse_entered():
	if not is_dragging:
		pickup_sound.play()
		card_base.z_index = 100
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging:
		card_base.z_index = 0
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), SPEED)
