extends Unit
class_name EnemyUnit

var chosen_card_stats : CardStats

var has_taken_turn = false

signal enemy_is_waiting_for_response()
signal enemy_has_taken_turn()

@export var battle_scene : BattleScene
@export var hand_of_cards : HandOfCards
@export var enemy_card_container : EnemyCardContainer
@export var enemy_container : EnemyController
	
func take_turn():
	enemy_card_container.enemy_card_template.active_enemy = self
	enemy_container = get_parent()
	enemy_container.animations.animation_finished.connect(animationSequencer)
#	setup a new card from the goblins deck
	chosen_card_stats = unit_stats.deck.pick_random()
	enemy_container.enemy_card.card_stats = chosen_card_stats
	enemy_container.animations.play("fly_in")
	
func animationSequencer(anim_name):
	if anim_name == 'fly_in':
		enemy_container.animations.play('hover')
		enemy_is_waiting_for_response.emit()
	if anim_name == 'evaporate':
		enemy_has_taken_turn.emit()
		enemy_container.animations.animation_finished.disconnect(animationSequencer)
