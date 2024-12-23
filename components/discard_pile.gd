extends Node2D

var num_in_discard : int
@onready var number_discarded = $DiscardNumber/NumberDiscarded

# Called when the node enters the scene tree for the first time.
func _ready():
	num_in_discard = 0

func addOneToDiscard():
	print('add one')
	num_in_discard += 1
	if num_in_discard > 9:
		number_discarded.add_theme_font_size_override("font_size", 22) 
		number_discarded.text = str(num_in_discard)

func removeOneFromDiscard():
	print('remove one')
	num_in_discard -= 1
	if num_in_discard > 9:
		number_discarded.add_theme_font_size_override("font_size", 22) 
		number_discarded.text = str(num_in_discard)	
		
func updateDiscardNumber(discardPileSize):
	if discardPileSize > num_in_discard:
		while discardPileSize > num_in_discard:
			await get_tree().create_timer(0.1).timeout
			addOneToDiscard()
	else:
		while discardPileSize < num_in_discard:
			await get_tree().create_timer(0.1).timeout
			removeOneFromDiscard()
