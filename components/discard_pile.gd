extends Node2D

@onready var number_discarded = $DiscardNumber/NumberDiscarded
@onready var number_burned: Label = $BurnNumber/NumberBurned
var num_in_discard : int :
	set(value):
#		store old value
		var oldValue = num_in_discard
#		get difference between oldValue and new
		var difference = value - oldValue
#		set new value
		num_in_discard = value
#		animate to new value from old value
		animateNumberFromBy(oldValue, difference)
			
		
# Called when the node enters the scene tree for the first time.
func _ready():
	number_discarded.text = str(num_in_discard)

func animateNumberFromBy(from: int, difference: int):
	while difference:
		
	await get_tree().create_timer(0.1).timeout
		
