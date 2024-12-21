extends CardStats
class_name HealingCard

func card_effect(target: Unit):
	var healAmount = calculate_adj_value()
		
	while healAmount > 0:
		await target.get_tree().create_timer(0.15).timeout
		healAmount -= 1
		target.addToHealth()
