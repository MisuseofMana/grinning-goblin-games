extends Node2D
class_name EnemyCardContainer

@onready var card : CardComponent = $Path2D/PathFollow2D/Card
@onready var anims = $EnemyCardAnimations

@onready var accept_button = $AcceptButton
@export var playerUnit : UnitSprite

var card_owner : UnitSprite

signal card_effect_finished()

func onCardAccept():
	card.card_stats.card_effect(playerUnit)
	accept_button.hide()
	anims.play('evaporate')

func onOwnershipChange(unit : UnitSprite):
	card_owner = unit

func onCardUpdate(stats : CardStats):
	card.card_stats = stats.duplicate()
	card.updateCardData()

func showAcceptButton():
	accept_button.show()
	
func on_animation_finished(anim_name):
	if anim_name == 'evaporate':
		card_effect_finished.emit()
		anims.play('RESET')
