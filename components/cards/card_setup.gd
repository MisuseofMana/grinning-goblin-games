extends Control
class_name CardImage

@onready var scene_base = $"."
@onready var rich_card_description: RichTextLabel = $RichCardDescription
@onready var card_image_slot: TextureRect = $CardImageSlot
@onready var card_name: Label = $CardName
@onready var card_cost_label: Label = $CostIndicator/CardCostLabel
@onready var card_base: TextureRect = $CardBase
@onready var cost_indicator = $CostIndicator

@export var card_stats : CardStats
@export var isEditingDeck : bool = false

signal card_added_to_deck(card)

const SPEED := 0.2
const delay := 4
var local_card_pos
var is_dragging = false
var is_disabled = false :
	set(value):
		is_disabled = value
		modulate = Color(1,1,1,0.2) if is_disabled == true else Color(1,1,1,1)
var overlappingAreas : Array[Area2D] = []

const PLAYER = preload("res://components/units/UnitDictionary/UnitTypes/player.tres")

func setCardData():
	card_base.texture = card_stats.card_skin
	card_name.text = card_stats.readable_name
	if card_stats.card_description.contains('%'):
		rich_card_description.text = card_stats.card_description % GameLogic.calculateCardCost(card_stats, PLAYER, false)
	else:
		rich_card_description.text = card_stats.card_description

	card_image_slot.texture = card_stats.card_image 
	card_cost_label.text = str(card_stats.play_cost)
	local_card_pos = scene_base.position

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(self, "global_position", get_global_mouse_position() - Vector2(51,65), delay * delta)
		
func _card_display_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT && not is_disabled:
		if event.is_pressed():
			self.z_index = 100
			create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
			if not local_card_pos:
				local_card_pos = self.position
			is_dragging = true
		else:
			self.z_index = 0
			if overlappingAreas.size():
				card_added_to_deck.emit(card_stats)
				self.visible = false
			else:
				returnCardToOrigin()
				
func onEnteringDeckZone(area):
	overlappingAreas.push_front(area)
	
func onExitingDeckArea(area):
	overlappingAreas.erase(area)

func returnCardToOrigin():
	create_tween().tween_property(self, "position", local_card_pos, SPEED)
	is_dragging = false
	
func hideIndicator():
	cost_indicator.hide()
