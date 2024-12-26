@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

@export var deck : Array[CardStats]
@export var hand_size : int = 5

func shuffle_deck():
	deck.shuffle()
	
func get_random_card():
	return deck.pick_random()
