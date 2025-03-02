class_name DeckPile extends Control

@onready var label = $DiscardChit/Label
@export var discardNode : DiscardPile

signal cards_drawn(whatCards: Array[CardStats])

func _ready():
	update_deck_label()
	
func shuffle_deck():
	GameState.playerDeck.shuffle()
	
func update_deck_label():
	label.text = str(GameState.playerDeck.size())

func add_discarded_cards_to_deck():
	GameState.playerDeck.append_array(discardNode.discard_array)
	shuffle_deck()
	update_deck_label()

func draw_cards_from_deck(howMany: int):
	if GameState.playerDeck.size() < GameState.hand_size:
		add_discarded_cards_to_deck()
	var drawnHand : Array
	for n in GameState.hand_size:
		if not GameState.playerDeck.is_empty():
			drawnHand.append(GameState.playerDeck.pop_front())
	update_deck_label()
	cards_drawn.emit(drawnHand)
