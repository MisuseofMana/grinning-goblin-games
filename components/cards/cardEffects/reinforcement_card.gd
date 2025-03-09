extends CardEffect
class_name ReinforcementCard

#meant to be overwritten in extended CardStats scripts 
func _run_card_effect(_target: BattleUnit):
	print('summonning a reinforcement')
