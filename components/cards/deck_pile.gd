extends Node2D

@onready var number: Label = $DiscardNumber/NumberDiscarded

var label_number : int = 0 :
	set(value):
		label_number = value
		number.text = str(label_number)
	get:
		return label_number
