extends CardEffect
class_name ActionPointCard

func _run_card_effect(target: BattleUnit):
	var apNode : ActionPoints = get_tree().get_first_node_in_group('action_point_node')
	print(get_tree().get_first_node_in_group('action_point_node'))
	apNode.increase_ap_by(card.calculate_adj_value())
	
