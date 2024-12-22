extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var discard_pile = $DiscardPile
@onready var card_base: Card = $CardArc/CardFollowPath/CardBase
@onready var action_points_counter = $Sprite2D/ActionPointsCounter
@onready var gpu_particles_2d = $Sprite2D/GPUParticles2D

@export var battleScene : BattleScene
@export var player : Unit

const CARD = preload("res://components/cards/draggable_card.tscn")

signal ran_out_of_action_points()

var max_action_points_remaining : int = 3
var action_points_remaining : int = 3
var hand_size : int = 5
var discardArray : Array = []

@onready var deck = player.unit_stats.deck

func _ready():
	action_points_counter.text = str(max_action_points_remaining)
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
	
	deck.shuffle()
	drawCards(hand_size)
		
func add_random_card_to_hand():
	drawCards(1)

func playerTurnSetup():
	await discardHand()

func addCardToHand(cardResource: CardStats):
	var newFollowNode = PathFollow2D.new()
	var newCard = CARD.instantiate()
	newCard.scale = Vector2(0,0)
	newCard.card_stats = cardResource
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	
	newCard.add_to_discard_number.connect(handleDiscardNumber)
	newCard.action_points_reduced.connect(reduceActionPointsBy)
	newCard.hand_of_cards = self

	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
		create_tween().tween_property(newCard, "scale", Vector2(1,1), 0.4)
		paper_sound.play()
		path_division += pos_incrementer
	changeCardAvailibilty(newCard)

func handleDiscardNumber(howMany):
	discard_pile.addNumToDiscard(howMany)
		
func discardHand():
#remove card from hand
#add card to discard array
	for followPath in card_arc.get_children():
		var card = followPath.get_child(0)
		card.add_to_discard_number.disconnect(handleDiscardNumber)
		card.action_points_reduced.disconnect(reduceActionPointsBy)
		discardArray.append(card)
		create_tween().tween_property(card, "global_position", Vector2(606, 378), 0.4)
		card.anims.play("go_to_discard")
		await card.anims.animation_finished
		followPath.queue_free()
		await followPath.tree_exited
	drawCards(hand_size)

func drawCards(howMany):
	if len(deck) < howMany:
		deck.append(discardArray)
		deck.shuffle()
	
	var incr = howMany
	while incr > 0:
		var chosenCard = deck.pop_at(0)
		addCardToHand(chosenCard)
		incr -= 1
	
func changeCardAvailibilty(cardNode):
		if useable(cardNode):
			cardNode.modulate = Color(1, 1, 1)
			cardNode.undraggable = false
			create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, -64), 0.2)
		else:
			cardNode.modulate = Color(0.2, 0.2, 0.2)
			cardNode.undraggable = true
			cardNode.z_index = 0
			create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, -50), 0.2)

func useable(cardNode : Card):
	if cardNode.card_stats.play_cost > action_points_remaining:
		return false
	var canUseAsResponse = not battleScene.players_turn and cardNode.card_stats.can_use_to_respond
	var canUseOnTurn = not cardNode.card_stats.can_use_to_respond and battleScene.players_turn
	return canUseAsResponse or canUseOnTurn
	
func reduceActionPointsBy(howMany):
	action_points_remaining -= howMany
	action_points_counter.text = str(action_points_remaining)
	if action_points_remaining <= 0:
		ran_out_of_action_points.emit()
		
func playerHasCardsThatCanBeUsed():
	if action_points_remaining <= 0:
		return false
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		if useable(cardNode) == true:
			return true

func changeAllCardAvailability():
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		changeCardAvailibilty(cardNode)
