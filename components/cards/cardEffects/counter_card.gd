extends CardEffect
class_name CounterCard

func _run_card_effect(target: CardComponent):
	target.card_countered.emit()
	
