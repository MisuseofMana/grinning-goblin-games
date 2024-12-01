class_name Card extends Node2D

@onready var scene_base = $"."
@onready var card_base: TextureRect = $CardBase
@onready var card_image: TextureRect = $CardBase/CardImageSlot
@onready var card_description: Label = $CardBase/CardDescription
@onready var card_name: Label = $CardBase/CardName
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound

@onready var pickup_sound = $MouseOverSound
@onready var valid_drop_sound = $ValidDropSound

@onready var anims = $CardAnimations
@onready var card_shimmer = $CardShimmer

@export var card_data : CardStats
@onready var global_pos: Label = $CardBase/GlobalPos
@onready var local_pos: Label = $CardBase/LocalPos

signal add_to_discard_number(howMany)
signal handle_card_deletion(nodeReference)

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

var overlappingAreas : Array[Area2D] = []

var is_dragging = false
var undraggable = false
var global_card_pos
var local_card_pos
var card_rotation
const SPEED := 0.2
const delay := 4

var discardAnimFinished = false
var discardAudioFinished = false

func _ready() -> void:
	if not card_data:
		queue_free()
	else: 
		card_name.text = card_data.readable_name
		card_description.text = card_data.card_description
		card_image.texture = card_data.card_image 

func _physics_process(delta):
	if is_dragging && not undraggable:
		create_tween().tween_property(self, "global_position", get_global_mouse_position(), delay * delta)
		card_shimmer.emitting = true

func _on_card_base_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
			if not local_card_pos:
				local_card_pos = scene_base.position
			global_pos.text = str(global_card_pos)
			local_pos.text = str(local_card_pos)
			scene_base.get_parent().rotation = 0
			is_dragging = true
		else:
			if overlappingAreas.size():
				var unitdata : UnitStats = overlappingAreas[0].get_parent().unit_data
				var is_self : bool = unitdata.is_self
				if is_self == card_data.targets_self:
					is_dragging = false
					undraggable = true
					scene_base.global_position = get_global_mouse_position()
					create_tween().tween_property(self, "global_position", Vector2(606, 278), 0.4)
					valid_drop_sound.play()
					anims.play('go_to_discard')
					
					var card_effects : Array
					for effect in card_data.effect_types:
						card_effects.append({
							'name': effect,
							'value': card_data.base_value
						})
					
					unitdata.run_card_effects(card_effects)
				else:
					error_sound.play()
					returnCardToHand()
			else:
				pickup_sound.play()
				returnCardToHand()
					
func returnCardToHand():
	scene_base.get_parent().rotation = card_rotation
	create_tween().tween_property(self, "position", local_card_pos, SPEED)
	card_shimmer.emitting = false
	is_dragging = false
	_on_mouse_exited()

func _on_mouse_entered():
	if not is_dragging && not undraggable:
		if not card_rotation:
			card_rotation = scene_base.get_parent().rotation
		card_base.z_index = 100
		pickup_sound.play()
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging && not undraggable:
		card_base.z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)

func _on_area_2d_area_entered(area):
	overlappingAreas.push_front(area)
	if overlappingAreas.size() && not undraggable:
#		if target types match
		if overlappingAreas[0].get_parent().unit_data.is_self == card_data.targets_self:
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

func addToDiscard(howMany):
	add_to_discard_number.emit(howMany)
	queue_free()
	
func allQueuesFinished():
	add_to_discard_number.emit(1)
	handle_card_deletion.emit(self)
	
func _on_card_animations_animation_finished(anim_name):
	if anim_name == 'go_to_discard':
		discardAnimFinished = true
	if discardAudioFinished:
		allQueuesFinished()

func _on_valid_drop_sound_finished():
	discardAudioFinished = true
	if discardAnimFinished:
		allQueuesFinished()
