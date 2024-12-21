extends CardStats
class_name DamagingCard

func card_effect(target: Unit):
	var reductionAmount = calculate_adj_value()
	
	while reductionAmount > 0:
		await target.get_tree().create_timer(0.1).timeout
		reductionAmount -= 1
		target.subtractFromHealth()
