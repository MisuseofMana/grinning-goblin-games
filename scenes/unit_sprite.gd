@icon("res://icons/UnitSprite.svg")
extends AnimatedSprite2D
class_name UnitSprite

@onready var collision = $TwoWayDetection/CollisionShape2D

@export var anims : AnimationPlayer
@export var deck : DeckNode
@export var health : HealthNode
@export var stats : StatsNode

func die():
	if stats.is_self:
		print('game over')
	else:
		anims.play('death_animation')
		
func takeDamage(howMuch):
	health.take_damage(howMuch)
	
func addToHealth(howMuch):
	health.heal(howMuch)
	
func take_turn():
	print('take_turn is not overwritten')
	pass

func disableTargeting():
	collision.disabled = true

func enableTargeting():
	collision.disabled = false
