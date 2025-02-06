extends Node


@export var playerDeck : Array[CardComponent] = []
@export var action_points : int = 3

signal ap_reduced(howMuch : int)

#region Deck Manipulation
var target_label: Label

var cardDeckPile: Array[PackedScene] = []:
	set(newArray):
		animateLabelToFrom(newArray.size(), cardDeckPile.size())
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
