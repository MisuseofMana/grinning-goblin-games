@tool
extends Control
class_name DiscardNode

@export var player : UnitTarget :
	set(newValue):
		player = newValue
		_get_configuration_warnings()

@onready var number_discarded : Label = $DiscardCardBack/MarginContainer/DiscardChit/NumberDiscarded
@onready var number_burned: Label = $BurnCardBack/MarginContainer/BurnChit/NumberBurned

func _get_configuration_warnings():
	var errors : Array[String] = []
	if not player:
		errors.append("Player export must be assigned.")
	return errors

func packCard(card: CardComponent):
	var packContainer = PackedScene.new()
	return packContainer.pack(card)

func generate_new_pile(cards: Array[CardComponent], combineWith: Array[PackedScene]) -> Array[PackedScene]:
	var addedCards: Array[PackedScene]
	for card in cards:
		addedCards.append(packCard(card))
	addedCards.append_array(combineWith)
	return addedCards

func add_cards_to_discard(cards: Array[CardComponent]):
	GameState.cardDiscardPile = generate_new_pile(cards, GameState.cardDiscardPile)

func add_cards_to_burn(cards: Array[CardComponent]):
	GameState.cardBurnPile = generate_new_pile(cards, GameState.cardBurnPile)
