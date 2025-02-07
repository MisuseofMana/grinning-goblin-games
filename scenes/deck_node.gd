@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

@export var deck : Array[PackedScene]
@export var hand_size : int = 5

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func add_discard_to_deck(discardArray : Array[PackedScene]):
	deck.append_array(discardArray)
