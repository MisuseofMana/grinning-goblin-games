extends CardEffect
class_name TokenCard

@export var tokenScene: PackedScene

func _run_card_effect(target: UnitTarget):
	var readout : TargetReadout = target.battle_readout
	readout.add_token(tokenScene, card.calculate_adj_token_value())
