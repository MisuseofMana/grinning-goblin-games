class_name Card extends Node2D

@onready var scene_base: Card = $"."
@onready var present: Control = $CardDisplay
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound
@onready var pickup_sound = $MouseOverSound
@onready var valid_drop_sound = $ValidDropSound
@onready var anims = $CardAnimations
@onready var card_shimmer = $CardShimmer

@export var card_stats : CardStats
@export var hand_of_cards : HandOfCards

signal card_burnt(followNode : PathFollow2D)
signal card_discarded(followNode : PathFollow2D)
signal reduce_action_points(play_cost: int)

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")
const PLAYER = preload("res://components/units/UnitDictionary/UnitTypes/player.tres")

var overlappingAreas : Array[Area2D] = []

var is_dragging : bool = false
var undraggable: bool = false
var global_card_pos
var local_card_pos
var card_rotation
const SPEED := 0.2
const delay := 4

var discardAnimFinished = false
var discardAudioFinished = true
		
func _physics_process(delta):
	if is_dragging && not undraggable:
		create_tween().tween_property(self, "global_position", get_global_mouse_position(), delay * delta)
		card_shimmer.emitting = true

func _dragging_card_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if undraggable:
			error_sound.play()
		if event.is_pressed():
			create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
			if not local_card_pos:
				local_card_pos = scene_base.position
			scene_base.get_parent().rotation = 0
			is_dragging = true
		else:
			if overlappingAreas.size() and isValidTarget(overlappingAreas[0].get_parent()):
				if hand_of_cards.useable(self):
					card_shimmer.emitting = false
					useCardOn(overlappingAreas[0].get_parent())
				else:
					returnCardToHand()
			else:
				returnCardToHand()

func useCardOn(target):
	reduce_action_points.emit(self.card_stats.play_cost)
	is_dragging = false
	undraggable = true
	discardAudioFinished = false
	valid_drop_sound.play()
	card_stats.card_effect(target)
	if card_stats.one_use:
		anims.play('burn_card')
	else:
		goToDiscard()
	
func returnCardToHand():
	error_sound.play()
	scene_base.get_parent().rotation = card_rotation
	card_rotation = null
	create_tween().tween_property(self, "position", local_card_pos, SPEED)
	card_shimmer.emitting = false
	is_dragging = false
	_on_card_mouse_exited()

func _on_card_mouse_entered():
	if not is_dragging and not card_rotation:
			card_rotation = scene_base.get_parent().rotation
	if not is_dragging && not undraggable:
		present.z_index = 100
		pickup_sound.play()
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)
		#$ToolTip.show()

func _on_card_mouse_exited():
	if not is_dragging:
		present.z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
		#$ToolTip.hide()

func cardOverlapsAUnit(area: Area2D):
	overlappingAreas.push_front(area)
	if overlappingAreas.size() and not undraggable:
		if isValidTarget(overlappingAreas[0].get_parent()):
			create_tween().tween_property(self, 'modulate', Color(0.244, 1, 0.806), SPEED)
		else:
			create_tween().tween_property(self, 'modulate', Color(1, 0.397, 0.415), SPEED)

func cardStopsOverlappingAUnit(area):
	overlappingAreas.erase(area)
	if not overlappingAreas.size():
		create_tween().tween_property(self, 'modulate', Color(1, 1, 1), SPEED)

func isValidTarget(target):
	if target is CardImage:
		return card_stats.can_use_to_respond
	elif target is Unit:
		return card_stats.targets_self == target.unit_stats.is_self and not card_stats.can_use_to_respond

func goToDiscard():
	create_tween().tween_property(self, "global_position", Vector2(606, 278), 0.4)
	anims.play('go_to_discard')

func _on_card_animations_animation_finished(anim_name):
	match anim_name:
		'go_to_discard':
			card_discarded.emit(card_stats)
			self.get_parent().queue_free()
		'burn_card':
			card_burnt.emit(card_stats)
			self.get_parent().queue_free()
