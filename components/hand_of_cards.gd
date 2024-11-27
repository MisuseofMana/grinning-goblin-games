extends Node2D

@onready var card_arc = $CardArc
@onready var paper_sound = $PaperSound

func _ready():
	for card in card_arc.get_children():
		card_arc.remove_child(card)
		card.queue_free() 

func _on_button_pressed():
	var newFollowNode = PathFollow2D.new()
	var newCard = preload("res://components/cards/presentational_card.tscn").instantiate()
	newCard.scale = Vector2(0,0)
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
		create_tween().tween_property(newCard, "scale", Vector2(1,1), 0.4)
		paper_sound.play()
		path_division += pos_incrementer
