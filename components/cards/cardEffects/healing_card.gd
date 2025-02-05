extends CardEffect
class_name HealingCard

func _run_card_effect(target: UnitTarget):
	target.addToHealth(card.calculate_adj_value())
