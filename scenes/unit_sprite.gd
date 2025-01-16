@icon("res://icons/UnitSprite.svg")
extends AnimatedSprite2D
class_name UnitSprite

@onready var collision = $TwoWayDetection/CollisionShape2D

@export var anims : AnimationPlayer
@export var deckNode : DeckNode
@export var healthNode : HealthNode
@export var statsNode : StatsNode

func die():
	if statsNode.is_self:
		print('game over')
	else:
		anims.play('death_animation')
		
func takeDamage(howMuch):
	healthNode.take_damage(howMuch)
	
func addToHealth(howMuch):
	healthNode.heal(howMuch)
	
func take_turn():
	print('take_turn is not overwritten')
	pass

func disableTargeting():
	collision.disabled = true

func enableTargeting():
	collision.disabled = false
