extends Node2D

@onready var number_discarded = $DiscardNumber/NumberDiscarded

var label_number : int = 0 :
	set(value):
#		store old value
		var oldValue = label_number
#		set new value
		label_number = value
#		animate to new value from old value
		animateFromTo(oldValue, value)

# Called when the node enters the scene tree for the first time.
func _ready():
	number_discarded.text = str(label_number)

func animateFromTo(from: int, to: int):
	var incrementer = from
	while incrementer != to:
		var shouldIncrease = from < to
		await get_tree().create_timer(0.1).timeout
		if shouldIncrease:
			number_discarded.text = str(incrementer + 1)
			incrementer += 1
		else:
			number_discarded.text = str(incrementer - 1)
			incrementer -= 1
