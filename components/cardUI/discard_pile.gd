@tool
extends Control
class_name DiscardPile

@onready var discard_label : Label = $DiscardCardBack/MarginContainer/DiscardChit/NumberDiscarded
@onready var burned_label: Label = $BurnCardBack/MarginContainer/BurnChit/NumberBurned
@onready var discard_card_back = $DiscardCardBack

@onready var discardPosition: Vector2 = discard_card_back.position
@export var deck_position : Marker2D

@onready var burn_pile : Array[CardStats] = SaveData.burn_pile:
	set(newValue):
		Utilities.animateLabelFromTo(newValue.size(), burn_pile.size(), burned_label)
		burn_pile = newValue
		SaveData.burn_pile = newValue
		
@onready var discard_pile : Array[CardStats] = SaveData.discard_pile:
	set(newValue):
		Utilities.animateLabelFromTo(newValue.size(), discard_pile.size(), discard_label)
		discard_pile = newValue
		SaveData.discard_pile = newValue

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

func add_cards_to_discard(cards: Array[CardStats]):
	var newPile: Array[CardStats] = cards
	newPile.append_array(discard_pile)
	discard_pile = newPile

func add_cards_to_burn(cards: Array[CardStats]):
	var newPile : Array[CardStats]= cards
	newPile.append_array(burn_pile)
	burn_pile = newPile
		
