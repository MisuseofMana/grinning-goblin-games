extends CardStats
class_name DefensiveCard

#defend logic
func card_effect(target: CardStats):
	var reduceBy = calculate_adj_value()
	
	while reduceBy > 0:
		await target.get_tree().create_timer(0.1).timeout
		reduceBy -= 1
		target.reduceBaseValue()