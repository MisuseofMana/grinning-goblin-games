extends CardStats
class_name HealingCard

func card_effect(targetUnit: Unit, _ownerUnitStats : UnitStats):
	var target_unit = targetUnit.unit_stats
	var healingAmount
	if relevant_stats.has('endurance'):
		healingAmount = base_value + targetUnit.unit_stats.stats["endurance"]
	elif relevant_stats.has('knowledge'):
		healingAmount = base_value + targetUnit.unit_stats.stats["knowledge"]
		 
	while healingAmount > 0:
		await targetUnit.get_tree().create_timer(0.15).timeout
		healingAmount -= 1
		targetUnit.addToHealth()
