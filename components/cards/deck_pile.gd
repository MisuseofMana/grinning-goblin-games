extends Node2D

@onready var label = $Label
@export var player : UnitSprite

var deckArray : Array[CardStats] = [] :
	set(newArray):
		animateLabelFromTo(newArray.size(), deckArray.size(), label)
		deckArray = newArray

func _ready():
	deckArray = player.deckNode.deck
	label.text = str(deckArray.size())

func animateLabelFromTo(to: int, from: int, targetNode: Label):
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		targetNode.text = str(incrementer)
