extends CardEffect
class_name HealingCard

func _run_card_effect(target: BattleUnit):
	target.addToHealth(card.calculate_adj_value())
