@tool
class_name Card extends Node2D

@onready var card_base = $CardBase

@onready var card_image = $CardImageSlot
@onready var card_description = $CardDescription
@onready var card_name = $CardName
@onready var card_area = $Area2D

@onready var error_sound = $ErrorSound
@onready var pickup_sound = $MouseOverSound
@onready var valid_drop_sound = $ValidDropSound

@onready var anims = $CardAnimations
@onready var card_shimmer = $CardShimmer

@export var card_data : CardData

signal add_to_discard_number()

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

var overlappingAreas : Array[Area2D] = []

var is_dragging = false
var undraggable = false
var global_card_pos
var local_card_pos
const SPEED := 0.2
const delay := 4

func _ready():
	#call_deferred("calculateOffsets")
	if(card_data):
		card_name.text = card_data.card_name
		card_description.text = card_data.card_description
		card_image.texture = card_data.card_image
	else: 
		card_name.text = 'Missing Data'
		card_description = ''
		card_image.texture = null

func calculateOffsets():
	#global_card_pos = self.get_parent().global_position + self.size/2
	#local_card_pos = self.global_position - self.get_parent().global_position
	pass

func _physics_process(delta):
	if is_dragging && not undraggable:
		create_tween().tween_property(self, "position", get_global_mouse_position() - global_card_pos, delay * delta)
		card_shimmer.emitting = true
		
func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
		else:
			if overlappingAreas.size():
				var targetTypeFromOverlap = overlappingAreas[0].get_parent().unit_data.target_type
				if targetTypeFromOverlap == card_data.valid_target:
					is_dragging = false
					undraggable = true
					create_tween().tween_property(self, "position", Vector2(824, 408) - global_card_pos, 1)
					anims.play('go_to_discard')
				else:
					error_sound.play()
					returnCardToHand()
			else:
				pickup_sound.play()
				returnCardToHand()
					
func returnCardToHand():
	create_tween().tween_property(self, "position", local_card_pos, SPEED)
	card_shimmer.emitting = false
	is_dragging = false
	_on_mouse_exited()

func _on_mouse_entered():
	if not is_dragging && not undraggable:
		pickup_sound.play()
		card_base.z_index = 100
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging && not undraggable:
		card_base.z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)

func _on_area_2d_area_entered(area):
	overlappingAreas.push_front(area)
	if overlappingAreas.size() && not undraggable:
		if overlappingAreas[0].get_parent().unit_data.target_type == card_data.valid_target:
			create_tween().tween_property(self, 'modulate', Color(0.244, 1, 0.806), SPEED)
		else:
			create_tween().tween_property(self, 'modulate', Color(1, 0.397, 0.415), SPEED)

func _on_area_2d_area_exited(area):
	overlappingAreas.erase(area)
	if not overlappingAreas.size():
		create_tween().tween_property(self, 'modulate', Color(1, 1, 1), SPEED)

func swapCardBackTexture():
	card_image.hide()
	card_description.hide()
	card_name.hide()
	card_base.texture = CARD_TEMPLATE_BACK
