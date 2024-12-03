extends CardStats

signal health_reduced()

func card_effect(unit: Unit):
	var damageAmount
	if relevant_stats.has('muscle'):
		damageAmount = base_value + unit.unit_stats.muscle - unit.defense
	elif relevant_stats.has('knowledge'):
		damageAmount = base_value - unit.unit_stats.ward
		 
	while damageAmount > 0:
		await unit.get_tree().create_timer(0.15).timeout
		damageAmount -= 1
		unit.subtractFromHealth()
