extends TextureRect
class_name CardBar

@onready var label: Label = $Label
@onready var dot_container: Control = $DotContainer

@export var card_stats : CardStats = null :
	set(value):
		card_stats = value
		#var incrementer = 0
		#var dotChildren = dot_container.get_children()
		#for item in deckCards:
			#if item == card:
				#dotChildren[incrementer].self_modulate = Color(0,1,0)
				#incrementer += 1
		#card_bar_container.add_child(newCardBar)
	get:
		return card_stats
