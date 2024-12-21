extends Unit
class_name Goblin

var card_ref : EnemyController

func take_turn():
#	take damage from tokens
	card_ref = get_parent()
	card_ref.animations.animation_finished.connect(animationSequencer)
#	setup a new card from the goblins deck
	var chosen_card_stats : CardStats = unit_stats.deck.pick_random()
	card_ref.enemy_card.card_stats = chosen_card_stats
	card_ref.animations.play("fly_in")
	
# animate card into scene
# wait for player interaction
func animationSequencer(anim_name):
	if(anim_name == 'fly_in'):
		card_ref.animations.play('hover')
#		check player card abilities for intterupts
#		auto proceed if no available options
		print('waiting for player input')
#		dole out card effect
#		proceed to next enemies turn
#		return play to player
	
func nextEnemyTurn():
	#next enemy takes turn
	pass
