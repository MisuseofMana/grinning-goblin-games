extends Unit

var card_ref : EnemyController
var chosen_card_stats : CardStats

@export var battle_scene : BattleScene
@export var hand_of_cards : HandOfCards
@export var enemy_card_container : EnemyCardContainer

func take_turn():
	enemy_card_container.enemy_card_template.active_enemy = self
	card_ref = get_parent()
	card_ref.animations.animation_finished.connect(animationSequencer)
#	setup a new card from the goblins deck
	chosen_card_stats = unit_stats.deck.pick_random()
	card_ref.enemy_card.card_stats = chosen_card_stats
	card_ref.animations.play("fly_in")
	
func animationSequencer(anim_name):
	if anim_name == 'fly_in':
		card_ref.animations.play('hover')
#		proceed to next enemies turn
#		return play to player
	if anim_name == 'evaporate':
		battle_scene.return_to_players_turn()
	card_ref.animations.animation_finished.disconnect(animationSequencer)
	
func nextEnemyTurn():
	#next enemy takes turn
	pass
