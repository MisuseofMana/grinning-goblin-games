extends Control
class_name DiscardNode

@export var player : UnitSprite

@onready var number_discarded : Label = $DiscardCardBack/MarginContainer/DiscardChit/NumberDiscarded
@onready var number_burned: Label = $BurnCardBack/MarginContainer/BurnChit/NumberBurned

var discardArray : Array = [] :
	set(newArray):
#		animate to new value from old value
		animateLabelFromTo(newArray.size(), discardArray.size(), number_discarded)
		discardArray = newArray

var burnArray : Array = [] :
	set(newArray):
#		animate to new value from old value
		animateLabelFromTo(newArray.size(), burnArray.size(), number_burned)
		burnArray = newArray
		
func _ready():
#	TODO: Hook up load state
#	set discard array to save file
#	set burn array to save file
	pass

func animateLabelFromTo(to: int, from: int, targetNode: Label):
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		targetNode.text = str(incrementer)

func updateDiscard(discard : Array):
	discardArray.append_array(discard)
	
func addToBurnPile(burn : Array):
	burnArray.append_array(burn)
