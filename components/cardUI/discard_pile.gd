@tool
extends Control
class_name DiscardPile

@onready var number_discarded : Label = $DiscardCardBack/MarginContainer/DiscardChit/NumberDiscarded
@onready var number_burned: Label = $BurnCardBack/MarginContainer/BurnChit/NumberBurned

# meant to handle the discard pile labels
# as well as contain the data for graveyard and exile

var discard_array: Array

func generate_new_pile(cards: Array[CardStats], combineWith: Array[CardStats]) -> Array[CardStats]:
	var addedCards: Array[CardStats]
	addedCards.append_array(combineWith)
	return addedCards

func add_cards_to_discard(cards: Array[CardStats]):
	GameState.target_label = number_discarded
	GameState.cardDiscardPile = generate_new_pile(cards, GameState.cardDiscardPile)

func add_cards_to_burn(cards: Array[CardStats]):
	GameState.target_label = number_burned
	GameState.cardBurnPile = generate_new_pile(cards, GameState.cardBurnPile)
