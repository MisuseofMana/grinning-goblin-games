extends Node
class_name BattleUnit

signal unit_died

@onready var collision = $TwoWayDetection/CollisionShape2D
@onready var unit_sprite = $UnitSprite
@onready var battle_readout = $BattleReadout

@export var anims : AnimationPlayer:
	set(newValue):
		anims = newValue
		update_configuration_warnings()
@export var healthNode : HealthNode :
	set(newValue):
		healthNode = newValue
		update_configuration_warnings()
@export var statsNode : StatsNode :
	set(newValue):
		statsNode = newValue
		update_configuration_warnings()
@export var targetingNode : TargetingInfo :
	set(newValue):
		targetingNode = newValue
		update_configuration_warnings()
@export var deckNode : DeckNode :
	set(newValue):
		deckNode = newValue
		update_configuration_warnings()

func _get_configuration_warnings():
	var errors : Array[String] = []
	if not healthNode:
		errors.append("HealthNode export must be assigned.")
	if not statsNode:
		errors.append("StatsNode export must be assigned.")
	if not anims:
		errors.append("Anims export must be assigned.")
	if not targetingNode:
		errors.append("Targeting Node export must be assigned.")
	if not deckNode:
		errors.append("Deck Node export must be assigned.")
	if deckNode.deck.is_empty():
		errors.append("Deck Node export must contain at least one card resource.")
	return errors

func die():
	anims.play('die')
		
func takeDamage(howMuch):
	healthNode.take_damage(howMuch)
	
func addToHealth(howMuch):
	healthNode.heal(howMuch)

func disableTargeting():
	collision.disabled = true

func enableTargeting():
	collision.disabled = false

func _on_animations_animation_finished(anim_name):
	if anim_name == 'die':
		unit_died.emit()
		queue_free()
