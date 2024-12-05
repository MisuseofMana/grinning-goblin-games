extends TextureRect
class_name Token

@export var token_stats : TokenStats
@onready var counter_icon = $"."
@onready var number_label = $NumberLabel

var tokenValue = 0

func _ready():
	texture = token_stats.token_icon
	number_label.text = str(tokenValue)
