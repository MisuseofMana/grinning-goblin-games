extends CardStats
class_name DamagingCard

func card_effect(targetUnit: Unit, ownerUnit : UnitStats):
	var damageAmount
		
	var targetArmor = targetUnit.unit_stats.tokens["ARMOR"] if targetUnit.unit_stats.tokens.has("ARMOR") else 0
	var targetWard = targetUnit.unit_stats.tokens["WARD"] if targetUnit.unit_stats.tokens.has("WARD") else 0
	
	if relevant_stats.has('muscle'):
		damageAmount = base_value + ownerUnit.stats["muscle"] - targetArmor
	elif relevant_stats.has('knowledge'):
		damageAmount = base_value - targetUnit.unit_stats.stats["knowledge"] - targetWard		 
	while damageAmount > 0:
		await targetUnit.get_tree().create_timer(0.1).timeout
		damageAmount -= 1
		targetUnit.subtractFromHealth()
