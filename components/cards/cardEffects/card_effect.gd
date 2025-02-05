class_name CardEffect extends Node

@onready var card : CardComponent = get_parent()

func _run_card_effect(target):
	print('card effect needs overridden')
