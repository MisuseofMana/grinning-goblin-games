extends Node2D
class_name EnemyCardContainer

@onready var area_2d = $Path2D/PathFollow2D/EnemyCardTemplate/Area2D
@onready var enemy_card_template :  = $Path2D/PathFollow2D/EnemyCardTemplate
@onready var anims = $EnemyCardAnimations

@onready var accept_button = $AcceptButton

var card_owner : Unit

func onCardAccept():
	enemy_card_template.runCardEffect(card_owner)
	accept_button.hide()
	anims.play('evaporate')

func onOwnershipChange(unit : Unit):
	card_owner = unit

func onCardUpdate(stats : CardStats):
	enemy_card_template.card_stats = stats

func showAcceptButton():
	accept_button.show()
