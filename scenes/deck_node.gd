@icon("res://icons/DeckNode.svg")
extends Node
class_name DeckNode

@export var deckPileNode: DeckPile
@export var discardPileNode : DiscardPile
@export var deck : Array[PackedScene]

func _ready():
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func add_discard_to_deck():
	deck.append_array(discardPileNode.discard)
	shuffle_deck()
		
		
