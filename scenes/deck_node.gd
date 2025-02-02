@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

signal discard_graveyard_updated(old_discard, new_discard)
signal burn_graveyard_updated(old_discard, new_discard)
signal hand_of_cards_changed(old_hand, new_hand)
signal deck_changed(old_deck, new_deck)
signal card_drawn(card)

@export var deck : Array[CardComponent]
@export var hand_size : int = 5

var currentHand : Array[CardComponent] = [] : 
	set(newHand):
		hand_of_cards_changed.emit(currentHand, newHand)
		currentHand = newHand

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func draw_hand_size():
	return add_card_to_hand(hand_size)

func add_discard_to_deck(discardArray : Array[CardComponent]):
	deck.append_array(discardArray)

func add_card_to_hand(howMany):
	var cardArray : Array[CardComponent]
	var incr = 0
	while incr < howMany:
		var drawnCard = deck.pop_front()
		cardArray.append(drawnCard)
		card_drawn.emit(drawnCard)
		incr += 1
	currentHand = cardArray
	return currentHand
