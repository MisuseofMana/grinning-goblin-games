class_name DeckPile extends Control

@onready var label = $DiscardChit/Label

# should contain logic for handling:
# supplying cards from the current deck configuration
# shuffling the deck
# handling card resources
# maintaining and displaying it's own deck count

func _ready():
	label.text = str(GameState.playerDeck.size())

func get_new_cards() -> Array:
	if GameState.playerDeck.size() < GameState.hand_size:
		add_discard_to_deck()
	var drawnHand : Array
	for n in GameState.hand_size:
		if not deck.is_empty():
			drawnHand.append(deck.pop_front())
	return drawnHand
	
func get_cards_from_deck(howMany):
	if GameState.cardDeckPile.size() <= howMany:
		var addDiscardToDeck : Array[PackedScene]
		addDiscardToDeck.append_array(GameState.cardDeckPile)
		addDiscardToDeck.append_array(GameState.cardDiscardPile)
		addDiscardToDeck.shuffle()
		GameState.cardDeckPile = addDiscardToDeck
		
	new_cards_drawn.emit(GameState.cardDeckPile.slice(0, howMany))
	update_deck_pile(GameState.cardDeckPile.slice(howMany, -1))

func update_deck_pile(newDeck: Array[PackedScene]):
	GameState.target_label = label
	GameState.cardDeckPile = newDeck
