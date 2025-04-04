extends CardEffect
class_name DefensiveCard

func _run_card_effect(target: CardComponent):
	var target_stats = target.card_stats
	var reduceBy = card.calculate_adj_value()
	target_stats.addToDebuff(reduceBy)
	target.updateCardData()
