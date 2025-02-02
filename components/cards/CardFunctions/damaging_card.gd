extends CardStats
class_name DamagingCard

func card_effect(target: EnemySprite):
	target.takeDamage(calculate_adj_value())
