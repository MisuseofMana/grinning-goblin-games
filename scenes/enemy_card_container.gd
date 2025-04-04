extends Node2D
class_name EnemyCardContainer

@onready var anims = $EnemyCardAnimations
@export var playerUnit : BattleUnit
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var card : CardComponent = $Path2D/PathFollow2D/Card
@onready var line_2d = $Line2D
@onready var card_target_indicator = $CardTargetIndicator

const CARD_BASE = preload("res://components/cards/card_base.tscn")

signal card_effect_finished()
signal show_accept_button()

func _ready():
	card.make_card_draggable.queue_free()
	card.mouse_default_cursor_shape = Control.CURSOR_ARROW

func hide_lines():
	line_2d.hide()
	card_target_indicator.hide()

func onCardAccept():
	if card.card_stats.targets_self:
		card.effect_node._run_card_effect(card.card_owner)
	else:
		card.effect_node._run_card_effect(playerUnit)
	anims.play('evaporate')
	hide_lines()

func counter_card():
	anims.play('evaporate')
	hide_lines()
	
func replace_card(cardStats: CardStats, newOwner: BattleUnit):
	card.card_owner = newOwner
	card.card_stats = cardStats
	card.card_stats.resetDebuffValue()
	card.updateCardData.call_deferred()
	anims.play('RESET')
	card.twoWayDetection.disableTargeting()
	line_2d.clear_points()
	line_2d.hide()
	anims.play("fly_in")
	
func on_animation_finished(anim_name):
	if anim_name == 'fly_in':
		card.twoWayDetection.enableTargeting()
		var startPosition = Vector2(-767.0, 182.0)
		var endPosition = (card.card_owner.global_position - line_2d.global_position) - Vector2(10, 96)
		line_2d.show()
		line_2d.add_point(startPosition)
		line_2d.add_point(startPosition.lerp(endPosition, 0.9))
		line_2d.add_point(endPosition)
		if not card.card_stats.targets_self:
			card_target_indicator.show()
		show_accept_button.emit()
		
	if anim_name == 'evaporate':
		card.twoWayDetection.disableTargeting()
		card_effect_finished.emit()
