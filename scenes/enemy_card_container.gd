extends Node2D
class_name EnemyCardContainer

@onready var area_2d = $Path2D/PathFollow2D/EnemyCardTemplate/Area2D
@onready var enemy_card_template : CardImage = $Path2D/PathFollow2D/EnemyCardTemplate
@onready var anims = $EnemyCardAnimations

@onready var accept_button = $AcceptButton

func onCardAccept():
	enemy_card_template.runCardEffect()
	accept_button.hide()
	anims.play('evaporate')
		
func showAcceptButton():
	accept_button.show()
	
