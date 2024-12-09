extends TextureRect
class_name CardBar

@onready var label: Label = $Label
@onready var dot_container: Control = $DotContainer

signal card_removed_from_deck(target)

var numberInDeck : int = 1 :
	set(value):
		var oldValue = numberInDeck
		if value > oldValue:
			modulateDot(value, false)
		else:
			modulateDot(value, true)
		numberInDeck = value
		if numberInDeck == 0:
			queue_free()

@export var card_stats : CardStats :
	set(value):
		card_stats = value
		label.text = card_stats.readable_name
	get:
		return card_stats

func _ready():
	dot_container.get_children()[numberInDeck - 1].self_modulate = Color(0, 0.992, 0.406)

func modulateDot(whichIdx : int, remove : bool):
	if remove:
		dot_container.get_children()[whichIdx].self_modulate = Color(1,1,1)
	else:
		dot_container.get_children()[whichIdx - 1].self_modulate = Color(0, 0.992, 0.406)

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			numberInDeck = numberInDeck - 1
			card_removed_from_deck.emit(card_stats)
