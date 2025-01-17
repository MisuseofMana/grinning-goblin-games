extends Node2D
class_name EnemyCardContainer

@onready var card : CardComponent = $Path2D/PathFollow2D/Card
@onready var anims = $EnemyCardAnimations
@export var playerUnit : UnitSprite

var card_owner : UnitSprite

signal card_effect_finished()
signal show_accept_button()

func onCardAccept():
	card.card_stats.card_effect(playerUnit)
	anims.play('evaporate')

func onOwnershipChange(unit : UnitSprite):
	card_owner = unit

func onCardUpdate(stats : CardStats):
	card.card_stats = stats.duplicate()
	card.updateCardData(stats)
	
func on_animation_finished(anim_name):
	if anim_name == 'fly_in':
		show_accept_button.emit()
	if anim_name == 'evaporate':
		card_effect_finished.emit()
		anims.play('RESET')
