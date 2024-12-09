extends Node2D
class_name DeckManagement

@onready var library_grid: GridContainer = $LibraryView/Library/LibraryGrid
@onready var deck_grid : GridContainer = $DeckView/Deck/DeckGrid
@onready var card_bar_container: VBoxContainer = $Sidebar/ScrollContainer/VBoxContainer

@export var cardsOwned : Array[CardStats] = []
@export var deckCards : Dictionary = {}

@onready var anims = $AnimationPlayer

const CARD_DISPLAY = preload("res://components/cards/card_display.tscn")
const DETECTION_AREA_CARD = preload("res://components/cards/detection_area_card.tscn")
const CARD_BAR = preload("res://components/cards/DeckManagement/card-bar.tscn")

var current_view : String = 'library'

signal deck_updated(deck_cards)

func _ready() -> void:
#	remove all cards in grid to ensure no lingering development cards exist
	for dummyCard in library_grid.get_children():
		dummyCard.queue_free()
	for dummyCard in deck_grid.get_children():
		dummyCard.queue_free()
		
	for card in cardsOwned:
		var newCard = CARD_DISPLAY.instantiate()
		newCard.card_stats = card
		library_grid.add_child(newCard)
		newCard.setCardData()
		var newArea = DETECTION_AREA_CARD.instantiate()
		newCard.add_child(newArea)
		newCard.isEditingDeck = true
		newCard.card_added_to_deck.connect(addCardToDeck)
		newCard.card_removed_from_deck.connect(removeCardFromDeck)
		newArea.area_entered.connect(newCard.onEnteringDeckZone)
		newArea.area_exited.connect(newCard.onExitingDeckArea)

func addCardToDeck(card: CardImage):
		var card_name = card.card_stats.card_name
		if deckCards.has(card_name):
			deckCards[card_name]['howMany'] += 1
		else:
			deckCards[card_name] = {
				'card_stats': card.card_stats,
				'howMany': 1
			}
		deck_updated.emit(deckCards[card_name])
	
func removeCardFromDeck(card: CardImage):
		var card_name = card.card_stats.card_name
		if deckCards.has(card_name):
			deckCards[card_name]['howMany'] -= 1
		deck_updated.emit(deckCards[card_name])
