class_name DeckPile extends Control

@onready var label = $DiscardChit/Label

@export var player : UnitTarget
@export var discardNode : DiscardNode

signal new_cards_drawn(cards: Array[PackedScene])

var stored_draw_count: int = 0

func _ready():
	update_deck_pile(player.deckNode.deck)
	label.text = str(GameState.cardDeckPile.size())

func get_cards_from_deck(howMany):
	print(GameState.cardDeckPile.size())
	if GameState.cardDeckPile.size() <= howMany:
		GameState.cardDiscardPile.shuffle()
		
	new_cards_drawn.emit(GameState.cardDeckPile.slice(0, howMany))
	update_deck_pile(GameState.cardDeckPile.slice(howMany, -1))
	

func update_deck_pile(newDeck: Array[PackedScene]):
	GameState.target_label = label
	GameState.cardDeckPile = newDeck
