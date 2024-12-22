extends Node2D
class_name DeckManagement

@onready var library_grid: GridContainer = $LibraryView/Library/LibraryGrid
@onready var deck_grid : GridContainer = $DeckView/Deck/DeckGrid
@onready var card_bar_container: VBoxContainer = $Sidebar/ScrollContainer/VBoxContainer

@export var cardsOwned : Array[CardStats] = []

@onready var anims = $AnimationPlayer
const CARD_DISPLAY = preload("res://components/cards/presentational_card.tscn")
const DETECTION_AREA_CARD = preload("res://components/cards/detection_area_card.tscn")
const CARD_BAR = preload("res://components/cards/DeckManagement/card-bar.tscn")

var current_view : String = 'library'

signal added_to_deck(cardStat: CardStats)

func _ready() -> void:
#	remove all cards in grid to ensure no lingering development cards exist
	for dummyCard in library_grid.get_children():
		dummyCard.queue_free()
	for dummyCard in deck_grid.get_children():
		dummyCard.queue_free()
		
	for card : CardStats in cardsOwned:
		addCardToLibrary(card)

func addCardToDeck(card: CardStats):
	added_to_deck.emit(card)
		
func removeCardFromDeck(cardStats: CardStats):
	addCardToLibrary(cardStats)
	
func addCardToLibrary(card: CardStats):
	var newCard = CARD_DISPLAY.instantiate()
	newCard.card_stats = card
	library_grid.add_child(newCard)
	newCard.setCardData()
	var newArea = DETECTION_AREA_CARD.instantiate()
	newCard.add_child(newArea)
	newCard.isEditingDeck = true
	newCard.card_added_to_deck.connect(addCardToDeck)
	newArea.area_entered.connect(newCard.onEnteringDeckZone)
	newArea.area_exited.connect(newCard.onExitingDeckArea)
		
func changeCardAvailibilty(cardName, disableBool : bool):
	for child : CardImage in library_grid.get_children():
		if child.card_stats.card_name == cardName:
			child.is_disabled = disableBool
		
