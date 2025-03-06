extends Node2D
class_name EnemyCardContainer

@onready var anims = $EnemyCardAnimations
@export var playerUnit : UnitTarget
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var card : CardComponent = $Path2D/PathFollow2D/Card

const CARD_BASE = preload("res://components/cards/card_base.tscn")

signal card_effect_finished()
signal show_accept_button()

func onCardAccept():
	if card.card_stats.targets_self:
		card.effect_node._run_card_effect(card.card_owner)
	else:
		card.effect_node._run_card_effect(playerUnit)
	anims.play('evaporate')
	
func replace_card(cardStats: CardStats, newOwner: UnitTarget):
	card.card_owner = newOwner
	card.card_stats = cardStats
	card.updateCardData.call_deferred()
	anims.play('RESET')
	anims.play("fly_in")
	
func on_animation_finished(anim_name):
	if anim_name == 'fly_in':
		show_accept_button.emit()
	if anim_name == 'evaporate':
		card_effect_finished.emit()
