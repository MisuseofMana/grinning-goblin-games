extends TextureRect

@onready var card_base = $"."
@onready var card_image = $CardImageSlot
@onready var card_description = $CardDescription
@onready var card_name = $CardName

@onready var pickup_sound = $MouseOverSound

@export var card_data : CardData

var is_dragging = false
var dragging_from_spot
const SPEED := 0.2
const delay := 4

func _ready():
	if(card_data):
		card_name.text = card_data.card_name
		card_description.text = card_data.card_description
		card_image.texture = card_data.card_image
	else: 
		card_name.text = 'Missing Data'
		card_description = ''
		card_image.texture = null

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(self, "position", get_global_mouse_position() - Vector2(52,68), delay * delta)
	
#replace with it's 2d counterpart
#make draggable
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			dragging_from_spot = self.global_position
			print(self.global_position)
			is_dragging = true
		else:
			if card_data.successfulDrag:
				#do something
				pass
			else:
				create_tween().tween_property(self, "position", dragging_from_spot, 0.2)
				is_dragging = false
				_on_mouse_exited()

func _on_mouse_entered():
	if not is_dragging:
		pickup_sound.play()
		card_base.z_index = 100
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging:
		card_base.z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
