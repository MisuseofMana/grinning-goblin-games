extends Node2D

@onready var number_discarded : Label = $DiscardNumber/NumberDiscarded
@onready var number_burned: Label = $BurnNumber/NumberBurned

var num_in_discard : int :
	set(value):
#		store old value
		var oldValue = num_in_discard
#		set new value
		num_in_discard = value
#		animate to new value from old value
		animateLabelFromTo(number_discarded, oldValue, value)

var num_in_burn : int :
	set(value):
#		store old value
		var oldValue = num_in_burn
#		set new value
		num_in_burn = value
#		animate to new value from old value
		animateLabelFromTo(number_burned, oldValue, value)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	number_discarded.text = str(num_in_discard)

func animateLabelFromTo(targetNode: Label, from: int, to: int):
	var incrementer = from
	while incrementer != to:
		var shouldIncrease = from < to
		await get_tree().create_timer(0.1).timeout
		if shouldIncrease:
			targetNode.text = str(incrementer + 1)
			incrementer += 1
		else:
			targetNode.text = str(incrementer - 1)
			incrementer -= 1
