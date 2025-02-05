extends CardEffect
class_name TokenCard

@export var token_resource : TokenStats

func _get_configuration_warning():
	if not token_resource.token_type:
		return 'Token Type Not Set'
	if not token_resource.token_icon:
		return 'Token Icon Not Set'
	return ''
	
func _run_card_effect(target: UnitTarget):
	var token_list : Dictionary = target.unit_stats.tokens
	var token_type : String = token_resource.token_type
	if token_list.has(token_type):
		token_list[token_type] += card.calculate_adj_token_value()
	else:
		token_list[token_type] = card.calculate_adj_token_value()
		
	target.updateTokens()
