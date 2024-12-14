extends CardStats
class_name ReinforcementCard

#meant to be overwritten in extended CardStats scripts 
func card_effect(targetUnit: Unit, _ownerUnitStats : UnitStats):
#	reinforce 
	print('summon a reinforcement')
	pass
