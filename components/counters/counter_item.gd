extends TextureRect
class_name CounterItem

@export var counter_data : CounterStats

@onready var counter_icon = $"."
@onready var number_label = $NumberLabel

func _ready():
	texture = counter_data.icon
	updateCounterValue(counter_data.value)

func updateCounterValue(value):
	number_label.text = str(value)
