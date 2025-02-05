extends CardEffect
class_name DefensiveCard

func _run_card_effect(target: CardComponent):
	var target_stats = target.card_stats
	var reduceBy = card.calculate_adj_value()
	
	while reduceBy > 0:
		await target.get_tree().create_timer(0.1).timeout
		reduceBy -= 1
		target_stats.addToDebuff()
