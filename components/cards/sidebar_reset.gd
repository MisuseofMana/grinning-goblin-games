extends Control

@onready var barList: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var label: Label = $Label

@export var inDeckColor : Color
@export var availableColor : Color

var oldDeck : Dictionary = {}

const CARD_BAR = preload("res://components/cards/DeckManagement/card-bar.tscn")

func _ready() -> void:
#	clear out development bars
	for item in barList.get_children():
		item.queue_free()

func handleSidebarUpdate(deck, card: CardImage):
	print(deck)
	if oldDeck.size() < deck.size():
		var newBar = CARD_BAR.instantiate()
		newBar.card_stats = card.card_stats
		barList.add_child(newBar)
		newBar.label.text = card.card_stats.readable_name
		newBar.dot_container.get_children()[0].self_modulate = inDeckColor
	for item : CardBar in barList.get_children():
		if item.card_stats.card_name == card.card_stats.card_name:
			item.dot_container.get_children()[]
		print(item.card_stats.card_name)
		
	oldDeck = deck
	return
	#var size = deck.size()
	#if deckSize < size:
		#var newBar = CARD_BAR.instantiate()
		#newBar.card_stats = card.card_stats
		#barList.add_child(newBar)
		#newBar.label.text = card.card_stats.readable_name
		#newBar.dot_container.get_children()[0].self_modulate = Color(0.1,0.8,0)
		#deckSize = size
	#elif deckSize == size:
		#var target = bars.find()	
		#print(target)
		#for bar : CardBar in bars:
			#pass
		#deckSize = size
