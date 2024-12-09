extends Control

@onready var deck_management = $".."
@onready var barList: VBoxContainer = $ScrollContainer/VBoxContainer

@export var inDeckColor : Color
@export var availableColor : Color

var cardsInDeck : Array[CardStats] = []

const CARD_BAR = preload("res://components/cards/DeckManagement/card-bar.tscn")

signal card_availibility_changed(cardName, disable)
signal deck_size_changed(value)

func _ready() -> void:
#	clear out development bars
	for item in barList.get_children():
		item.queue_free()

func addCardToSidebar(cardStats: CardStats):
	var cardName = cardStats.card_name
	var cardAlreadyInDeck = cardsInDeck.any(func(card : CardStats): return card.card_name == cardName)
	var numOfSameCards = cardsInDeck.filter(func(card : CardStats): return card.card_name == cardName).size()
	cardsInDeck.append(cardStats)
	if not cardAlreadyInDeck:
		var newBar = CARD_BAR.instantiate()
		barList.add_child(newBar)
		newBar.card_stats = cardStats
		newBar.dot_container.get_children()[0].self_modulate = inDeckColor
		newBar.card_removed_from_deck.connect(deck_management.removeCardFromDeck)
		newBar.card_removed_from_deck.connect(removeCardFromSidebar)
	elif cardAlreadyInDeck:
		if numOfSameCards == 3:
			card_availibility_changed.emit(cardName, true)
		elif numOfSameCards < 3:
			card_availibility_changed.emit(cardName, false)
		var targetBar : CardBar = barList.get_children().filter(
			func(card: CardBar): return card.card_stats.card_name == cardName)[0]
		targetBar.numberInDeck = numOfSameCards + 1
	
	deck_size_changed.emit(cardsInDeck.size())

func removeCardFromSidebar(cardStats: CardStats):
	cardsInDeck.erase(cardStats)
	deck_size_changed.emit(cardsInDeck.size())
