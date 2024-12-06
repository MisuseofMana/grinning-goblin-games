extends Node2D
class_name DeckManagement

@onready var library_grid: GridContainer = $LibraryView/Library/LibraryGrid
@onready var deck_grid : GridContainer = $DeckView/Deck/DeckGrid
@onready var deck_pile: Node2D = $LibraryView/LibraryDragArea/DeckPile

@export var cardsOwned : Array[CardStats] = []
@export var deckCards : Array[Control] = []

@onready var anims = $AnimationPlayer

const CARD_DISPLAY = preload("res://components/cards/card_display.tscn")
const DETECTION_AREA_CARD = preload("res://components/cards/detection_area_card.tscn")

var current_view : String = 'library'

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
		newCard.isEditingDeck = true
		newCard.card_added_to_deck.connect(addCardToDeck)
		newCard.card_removed_from_deck.connect(removeCardFromDeck)
		
	#for card in deckCards:
		#var newCard = CARD_DISPLAY.instantiate()
		#newCard.card_stats = card
		#deck_grid.add_child(newCard)
		#newCard.setCardData()
		#var newArea = DETECTION_AREA_CARD.instantiate()
		#newCard.add_child(newArea)
		#newCard.add_to_discard_number.connect(addCardToDeck)

func addCardToDeck(card: CardImage):
	if not deckCards.has(card):
		deckCards.append(card)
		card.modulate = Color(1,1,1,0.2)
		deck_pile.label_number = deckCards.size()
	
func removeCardFromDeck(card: CardImage):
	if deckCards.has(card):
		deckCards.erase(card)
		card.modulate = Color(1,1,1,1)
		deck_pile.label_number = deckCards.size()

func outlineCard():
	for card in library_grid.get_children():
		pass

func viewLibrary():
	anims.play("go_to_library")
	
func viewDeck():
	anims.play('go_to_deck')
