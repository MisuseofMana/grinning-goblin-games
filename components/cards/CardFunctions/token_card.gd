extends CardStats
class_name TokenCard

@export var token_resource : TokenStats

func _get_configuration_warning():
	if not token_resource.token_type:
		return 'Token Type Not Set'
	if not token_resource.token_icon:
		return 'Token Icon Not Set'
	return ''
	
func card_effect(targetUnit: Unit, ownerUnitStats : UnitStats):
	var token_list : Dictionary = targetUnit.unit_stats.tokens
	var token_type : String = token_resource.token_type
	
	if token_list.has(token_type):
		token_list[token_type] += GameLogic.calculateCardCost(self, ownerUnitStats, true)
	else:
		token_list[token_type] = GameLogic.calculateCardCost(self, ownerUnitStats, true)
		
	targetUnit.updateTokens()
