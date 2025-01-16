@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

signal discard_graveyard_updated(old_discard, new_discard)
signal burn_graveyard_updated(old_discard, new_discard)
signal hand_of_cards_changed(old_hand, new_hand)
signal deck_changed(old_deck, new_deck)
signal card_drawn(card)

@export var deck : Array[CardStats]
@export var hand_size : int = 5

var discardGraveyard : Array[CardStats] = [] :
	set(newDiscardGraveyard):
		discard_graveyard_updated.emit(discardGraveyard, newDiscardGraveyard)
		discardGraveyard = newDiscardGraveyard
var burnGraveyard : Array[CardStats] = [] :
	set(newBurnGraveyard):
		burn_graveyard_updated.emit(burnGraveyard, newBurnGraveyard)
		burnGraveyard = newBurnGraveyard
var currentHand : Array[CardStats] = [] : 
	set(newHand):
		hand_of_cards_changed.emit(currentHand, newHand)
		currentHand = newHand

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func draw_hand_size():
	return add_card_to_hand(hand_size)

func put_discard_into_deck():
	deck.append_array(discardGraveyard)
	shuffle_deck()

func add_card_to_burn_graveyard(card: CardStats):
	burnGraveyard.append(card)
	
func add_card_to_discard_graveyard(card : CardStats):
	discardGraveyard.append(card)
	
func add_card_to_hand(howMany):
	var cardArray : Array[CardStats]
	if deck.size() < howMany:
		put_discard_into_deck()
		
	var incr = 0
	while incr < howMany:
		var drawnCard = deck.pop_front()
		cardArray.append(drawnCard)
		card_drawn.emit(drawnCard)
		incr += 1
	deck = cardArray
