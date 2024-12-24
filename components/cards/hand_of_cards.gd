extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var card_base: Card = $CardArc/CardFollowPath/CardBase
@onready var action_points_counter = $Sprite2D/ActionPointsCounter
@onready var gpu_particles_2d = $Sprite2D/GPUParticles2D
@onready var discard_pile = $DiscardPiles

@export var battleScene : BattleScene
@export var player : Unit

const CARD = preload("res://components/cards/draggable_card.tscn")

var max_action_points : int = 3
var action_points_remaining : int = 3 : 
	set(value):
		action_points_remaining = value
		action_points_counter.text = str(max_action_points)
var hand_size : int = 5
var discardArray : Array = []
var burnArray : Array = []

@onready var deck = player.unit_stats.deck

signal action_points_depleted()

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
	
	deck.shuffle()
	drawCards(hand_size)
	
func refreshActionPoints():
	action_points_remaining = max_action_points
		
func add_random_card_to_hand():
	drawCards(1)

func playerTurnSetup():
	await discardHand()
	drawCards(hand_size)

func addCardToHand(cardResource: CardStats):
	var newFollowNode = PathFollow2D.new()
	var newCard = CARD.instantiate()
	newCard.scale = Vector2(0,0)
	newCard.card_stats = cardResource
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	
	newCard.hand_of_cards = self
	newCard.card_discarded.connect(putCardInDiscard)
	newCard.card_burnt.connect(putCardInBurnPile)
	newCard.tree_exited.connect(updateAllCardPositions)
	
	updateAllCardPositions()
	changeCardAvailibilty(newCard)

func putCardInDiscard(followNode : PathFollow2D):
	var card = followNode.get_child(0)
	discardArray.append(card.card_stats)
	discard_pile.updateDiscardNumber(discardArray.size())
	followNode.queue_free()
	
func putCardInBurnPile(followNode : PathFollow2D):
	var card = followNode.get_child(0)
	burnArray.append(card.card_stats)
	discard_pile.updateBurnNumber(burnArray.size())
	followNode.queue_free()
	
func discardHand():
	for followPath in card_arc.get_children():
		putCardInDiscard(followPath)
		
func drawCards(howMany):
	if deck.size() < howMany:
		deck.append_array(discardArray)
		discardArray = []
		discard_pile.updateDiscardNumber(discardArray.size())
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
		action_points_depleted.emit()
		
func playerHasCardsThatCanBeUsed():
	if action_points_remaining <= 0:
		return false
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		if useable(cardNode) == true:
			return true

func updateAllCardPositions():
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
		create_tween().tween_property(followPath.get_child(0), "scale", Vector2(1,1), 0.4)
		paper_sound.play()
		path_division += pos_incrementer

func changeAllCardAvailability():
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		changeCardAvailibilty(cardNode)
