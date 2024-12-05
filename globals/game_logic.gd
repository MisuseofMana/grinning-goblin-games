extends Node

func calculateCardCost(card_stats: CardStats, unit_stats: UnitStats, noBBCode: bool):
	var incrementer = card_stats.base_value
	var color
	for stat in card_stats.relevant_stats:
		incrementer += unit_stats.stats[stat]
	if(incrementer <= card_stats.base_value):
		color = Color(1,0,0).to_html()
	else: 
		color = Color(0,1,0.1).to_html()
	
	if noBBCode:
		return incrementer
	else:
		return "[color=%s]%s[/color]" % [color, incrementer]
