extends Node2D
class_name EnemyCardContainer

@onready var anims = $EnemyCardAnimations
@export var playerUnit : UnitTarget
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var card : CardComponent = $Path2D/PathFollow2D/Card
@onready var line_2d = $Line2D

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
	line_2d.clear_points()
	line_2d.hide()
	anims.play("fly_in")
	
func on_animation_finished(anim_name):
	if anim_name == 'fly_in':
		var startPosition = Vector2(-767.0, 182.0)
		var endPosition = (card.card_owner.global_position - line_2d.global_position) - Vector2(0, 96)
		line_2d.show()
		line_2d.add_point(startPosition)
		line_2d.add_point(startPosition.lerp(endPosition, 0.4))
		line_2d.add_point(startPosition.lerp(endPosition, 0.7))
		line_2d.add_point(startPosition.lerp(endPosition, 0.8))
		line_2d.add_point(startPosition.lerp(endPosition, 0.9))
		line_2d.add_point(endPosition)
		show_accept_button.emit()
	if anim_name == 'evaporate':
		line_2d.hide()
		card_effect_finished.emit()
