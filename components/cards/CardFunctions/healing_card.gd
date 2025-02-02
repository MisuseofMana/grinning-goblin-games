extends CardStats
class_name HealingCard

func card_effect(target: PlayerSprite):
	target.addToHealth(calculate_adj_value())
