extends Node2D

@export_group('Deck Info')
@export var playerDeck : Array[PackedScene] = []
@export var collectedCards : Array = []

@export_group('Card Battle Stats')
@export var action_points : int = 3
@export var max_action_points : int = 3
@export var hand_size: int = 5

var deck_setup_happened = false
signal ap_reduced(howMuch : int)

#region Deck Manipulation
var target_label: Label

var cardDeckPile: Array[PackedScene] = []:
	set(newArray):
		if deck_setup_happened:
			animateLabelToFrom(newArray.size(), cardDeckPile.size())
		else:
			deck_setup_happened = true
		cardDeckPile = newArray
		
var cardDiscardPile : Array[PackedScene] = []:
	set(newArray):
		animateLabelToFrom(newArray.size(), cardDiscardPile.size())
		cardDiscardPile = newArray

var cardBurnPile : Array[PackedScene] = []:
	set(newArray):
		animateLabelToFrom(newArray.size(), cardDiscardPile.size())
		cardBurnPile = newArray

func animateLabelToFrom(to: int, from: int):
	var label_node = target_label
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		label_node.text = str(incrementer)
#endregion
