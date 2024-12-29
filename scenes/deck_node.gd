@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

@export var deck : Array[CardStats]
@export var hand_size : int = 5
var discardArray : Array[CardStats] = []

@export var stats_node : StatsNode

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()
	
func get_random_card():
	return deck.pick_random()

func draw_hand_size():
	return draw_cards(hand_size)

func put_discard_into_deck():
	deck.append_array(discardArray)
	shuffle_deck()

func draw_cards(howMany):
	var cardArray : Array[CardStats]
	if deck.size() < howMany:
		put_discard_into_deck()
		
	var incr = 0
	while incr < howMany:
		cardArray.append(deck.pop_at(0))
		incr += 1
	return cardArray
