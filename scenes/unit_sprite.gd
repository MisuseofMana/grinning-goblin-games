@tool
@icon("res://icons/UnitSprite.svg")
extends AnimatedSprite2D
class_name UnitSprite

@onready var collision = $TwoWayDetection/CollisionShape2D

@export var anims : AnimationPlayer:
	set(newValue):
		anims = newValue
		update_configuration_warnings()
@export var deckNode : DeckNode :
	set(newValue):
		deckNode = newValue
		update_configuration_warnings()
@export var healthNode : HealthNode :
	set(newValue):
		healthNode = newValue
		update_configuration_warnings()
@export var statsNode : StatsNode :
	set(newValue):
		statsNode = newValue
		update_configuration_warnings()
@export var discardNode : DiscardNode :
	set(newValue):
		discardNode = newValue
		update_configuration_warnings()

func _get_configuration_warnings():
	var errors : Array[String] = []
	if not deckNode:
		errors.append("DeckNode export must be assigned.")
	if not healthNode:
		errors.append("HealthNode export must be assigned.")
	if not statsNode:
		errors.append("StatsNode export must be assigned.")
	if not anims:
		errors.append("Anims export must be assigned.")
	if not discardNode && statsNode.is_self:
		errors.append("DiscardNode must be assigned.")
	return errors

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
	
func add_cards_to_deck(cardArray : Array[CardStats]):
	deckNode.deck.append_array(cardArray)

func check_for_valid_draw(howMany):
	if deckNode.deck.size() < howMany:
		deckNode.add_discard_to_deck(discardNode.discardArray)
		deckNode.shuffle_deck()
	_draw_cards(howMany)

func _draw_cards(howMany):
	deckNode.add_card_to_hand(howMany)
	
