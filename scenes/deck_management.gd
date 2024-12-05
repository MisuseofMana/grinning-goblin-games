extends Node2D
class_name DeckManagement

@onready var library: ScrollContainer = $Library
@onready var library_grid: GridContainer = $Library/LibraryGrid

@export var cardsOwned : Array[CardStats] = []
@export var deckCards : Array[CardStats] = []

const CARD_DISPLAY = preload("res://components/cards/card_display.tscn")
const DETECTION_AREA_CARD = preload("res://components/cards/detection_area_card.tscn")

func _ready() -> void:
	for dummyCard in library_grid.get_children():
		dummyCard.queue_free()
	for card in cardsOwned:
		var newCard = CARD_DISPLAY.instantiate()
		newCard.card_stats = card
		library_grid.add_child(newCard)
		newCard.setCardData()
		var newArea = DETECTION_AREA_CARD.instantiate()
		newCard.add_child(newArea)

func addCardToDeck():
	pass
	
func removeCardFromDeck():
	pass
