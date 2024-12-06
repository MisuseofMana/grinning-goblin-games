extends Control

@onready var scene_base = $"."
@onready var rich_card_description: RichTextLabel = $RichCardDescription
@onready var card_image_slot: TextureRect = $CardImageSlot
@onready var card_name: Label = $CardName
@onready var card_cost_label: Label = $CostIndicator/CardCostLabel
@onready var card_base: TextureRect = $CardBase

@export var card_stats : CardStats
@export var isEditingDeck : bool = false

signal card_added_to_deck(card)
signal card_removed_from_deck(card)

const PLAYER = preload("res://components/units/UnitDictionary/UnitTypes/player.tres")

func setCardData():
	card_name.text = card_stats.readable_name
	rich_card_description.text = card_stats.card_description % GameLogic.calculateCardCost(card_stats, PLAYER, false)
	card_image_slot.texture = card_stats.card_image 
	card_cost_label.text = str(card_stats.play_cost)

func _card_display_gui_input(event):
	if not isEditingDeck:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			card_added_to_deck.emit(self)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			card_removed_from_deck.emit(self)
