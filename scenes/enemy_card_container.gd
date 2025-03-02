extends Node2D
class_name EnemyCardContainer

@onready var anims = $EnemyCardAnimations
@export var playerUnit : UnitTarget
@onready var path_follow_2d = $Path2D/PathFollow2D
@onready var testCard = $Path2D/PathFollow2D/Card

var cardInPlay : CardComponent
var card_owner : UnitTarget

signal card_effect_finished()
signal show_accept_button()

func _ready():
	testCard.queue_free()

func onCardAccept():
	cardInPlay.effect_node._run_card_effect(playerUnit)
	anims.play('evaporate')
	
func replace_card(card: Resource, newOwner: UnitTarget):
	if cardInPlay:
		cardInPlay.queue_free()
	var newCard : CardComponent = card.instantiate()
	newCard.card_owner = newOwner
	newCard.updateCardData.call_deferred()
	path_follow_2d.add_child(newCard)
	cardInPlay = newCard
	anims.play('RESET')
	anims.play("fly_in")
	
func on_animation_finished(anim_name):
	if anim_name == 'fly_in':
		show_accept_button.emit()
	if anim_name == 'evaporate':
		card_effect_finished.emit()
