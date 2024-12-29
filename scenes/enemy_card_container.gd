extends Node2D
class_name EnemyCardContainer

@onready var card = $Path2D/PathFollow2D/Card
@onready var anims = $EnemyCardAnimations

@onready var accept_button = $AcceptButton

var card_owner : Unit

func onCardAccept():
	card.runCardEffect(card_owner)
	accept_button.hide()
	anims.play('evaporate')

func onOwnershipChange(unit : Unit):
	card_owner = unit

func onCardUpdate(stats : CardStats):
	card.card_stats = stats

func showAcceptButton():
	accept_button.show()
