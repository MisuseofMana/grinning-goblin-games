extends CardStats
class_name HealingCard

func card_effect(target: UnitSprite):
	target.addToHealth(calculate_adj_value())
