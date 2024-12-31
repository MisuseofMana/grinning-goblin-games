extends CardStats
class_name DamagingCard

func card_effect(target: UnitSprite):
	target.takeDamage(calculate_adj_value())
