extends CardEffect
class_name DamagingCard

func _run_card_effect(target: UnitTarget):
	target.takeDamage(card.calculate_adj_value())
