@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

signal discard_graveyard_updated(old_discard, new_discard)
signal burn_graveyard_updated(old_discard, new_discard)
signal deck_changed(old_deck, new_deck)

@export var deck : Array[PackedScene]
@export var hand_size : int = 5

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func add_discard_to_deck(discardArray : Array[PackedScene]):
	deck.append_array(discardArray)
