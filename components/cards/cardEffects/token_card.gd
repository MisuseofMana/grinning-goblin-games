extends CardEffect
class_name TokenCard

@export_enum("poison", "ward", "armor") var token_type : String

func _run_card_effect(target: UnitTarget):
	var readout : TargetReadout = target.battle_readout
	readout.add_token(token_type, card.calculate_adj_token_value())
