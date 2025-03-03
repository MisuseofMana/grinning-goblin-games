class_name DeckPile extends Control

@onready var cardCount = $CountPip/CardsInDeck

signal cards_drawn(whatCards: Array[CardStats])
signal shuffle_discard_to_deck

@onready var deck_pile : Array[CardStats] = SaveData.deck_pile:
	set(newValue):
		Utilities.animateLabelFromTo(newValue.size(), deck_pile.size(), cardCount)
		deck_pile = newValue
		SaveData.deck_pile = newValue
		
@onready var hand_size : int = SaveData.hand_size:
	set(newValue):
		hand_size = newValue
		SaveData.hand_size = newValue

func saveData():
	SaveData.hand_size = hand_size
	SaveData.deck_pile = deck_pile

func draw_hand_size():
	if deck_pile.size() < hand_size:
		shuffle_discard_to_deck.emit()
	var drawnHand : Array[CardStats]
	var replaceDeckWith : Array[CardStats] = deck_pile.duplicate()
	for n in hand_size:
		if not deck_pile.is_empty():
			drawnHand.append(replaceDeckWith.pop_front())
	deck_pile = replaceDeckWith
	cards_drawn.emit(drawnHand)
