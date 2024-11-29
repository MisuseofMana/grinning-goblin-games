class_name Card extends Node2D

@onready var card_base: Sprite2D = $CardBase
@onready var card_image: Sprite2D = $CardImageSlot
@onready var card_description: Label = $CardDescription
@onready var card_name: Label = $CardName
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound

@onready var pickup_sound = $MouseOverSound
@onready var valid_drop_sound = $ValidDropSound

@onready var anims = $CardAnimations
@onready var card_shimmer = $CardShimmer

@export var card_data : BaseCard

@onready var global_pos: Label = $GlobalPos
@onready var local_pos: Label = $LocalPos

signal detatch_card_from_arc()

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

var overlappingAreas : Array[Area2D] = []

var is_dragging = false:
	set(value):
		print(value)
		is_dragging = value
		if value == true:
			detatch_card_from_arc.emit()
		
var undraggable = false
var global_card_pos
var local_card_pos
const SPEED := 0.2
const delay := 4

func _ready() -> void:
	if not card_data:
		queue_free()
	else: 
		card_name.text = card_data.readable_name
		card_description.text = card_data.card_description
		card_image.texture = card_data.card_image 
	
func _physics_process(delta):
	if is_dragging && not undraggable:
		create_tween().tween_property(self, "position", get_global_mouse_position(), delay * delta)
		card_shimmer.emitting = true

func _on_card_mouseover_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_dragging = true
		else:
			if overlappingAreas.size():
				var targetTypeFromOverlap = overlappingAreas[0].get_parent().unit_data.target_type
				if targetTypeFromOverlap == 'self' && card_data.targets_self:
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
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging && not undraggable:
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)

func _on_area_2d_area_entered(area):
	overlappingAreas.push_front(area)
	if overlappingAreas.size() && not undraggable:
		if overlappingAreas[0].get_parent().unit_data.target_type == 'self' && card_data.targets_self:
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
