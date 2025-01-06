extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var action_points_counter = $Sprite2D/ActionPointsCounter
@onready var ap_particles = $Sprite2D/GPUParticles2D
@onready var discard_pile = $DiscardPiles
@onready var deck_pile = $DeckPile

@export var battleScene : BattleScene
@export var player : UnitSprite

const CARD = preload("res://components/cards/draggable_card.tscn")

var max_action_points : int = 3
var action_points_remaining : int = 3
var discardArray : Array = []
var burnArray : Array = []

signal end_player_turn()

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
		
	action_points_counter.text = str(action_points_remaining) + '/' + str(max_action_points)
	
func refreshActionPoints():
	action_points_remaining = max_action_points
		
func add_random_card_to_hand():
	pass
	#drawCards(1)

func playerTurnSetup():
	await discardHand()
	#drawCards(hand_size)

func addCardToHand(cardResource: CardStats):
	var newFollowNode = PathFollow2D.new()
	var newCard = CARD.instantiate()
	newCard.scale = Vector2(1,1)
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	newCard.set_card_stats(cardResource)
	
	newCard.card_used.connect(handleCardUse)
	newCard.tree_exited.connect(updateAllCardPositions)
	newCard.tree_exited.connect(checkForValidPlayerActions)

	updateAllCardPositions()
	changeCardAvailibilty(newCard)
	
func discardHand():
	for followPath in card_arc.get_children():
		await self.get_tree().create_timer(0.2).timeout
		putCardInDiscard(followPath.get_child(0))

func putCardInDiscard(dragCard : DraggableCard):
	var card_stats : CardStats = dragCard.card.card_stats
	dragCard.anims.play('discard')
	create_tween().tween_property(dragCard, "global_position", Vector2(579,342), 0.6)
	discardArray.append(card_stats)
	discard_pile.num_in_discard = discardArray.size()
	
func putCardInBurnPile(dragCard : DraggableCard):
	var card_stats : CardStats = dragCard.card.card_stats
	dragCard.anims.play('burn')
	create_tween().tween_property(dragCard, "global_position", Vector2(600,315), 0.6)
	burnArray.append(card_stats)
	discard_pile.num_in_burn = burnArray.size()

func isCardUsable(cardNode : DraggableCard):
	if cardNode.card.card_stats.play_cost > action_points_remaining:
		return false
	var canUseAsResponse = not battleScene.players_turn and cardNode.card.card_stats.can_use_to_respond
	var canUseOnTurn = not cardNode.card.card_stats.can_use_to_respond and battleScene.players_turn
	return canUseAsResponse or canUseOnTurn or cardNode.card.card_stats.can_use_whenever
	
func handleCardUse(dragCard: DraggableCard):
	var card_stats : CardStats = dragCard.card.card_stats
	action_points_remaining -= card_stats.play_cost
	action_points_counter.text = str(action_points_remaining) + '/' + str(max_action_points)
	ap_particles.emitting = true
	
	if card_stats.one_use:
		putCardInBurnPile(dragCard)
	else:
		putCardInDiscard(dragCard)
	
	updateAllCardPositions()
		
func checkForValidPlayerActions():
	if action_points_remaining <= 0:
		if battleScene.players_turn:
			end_player_turn.emit()
	for followNode in card_arc.get_children():
		if not followNode.is_queued_for_deletion():
			var cardNode = followNode.get_child(0)
			if isCardUsable(cardNode) == true:
				return
	if battleScene.players_turn:
		end_player_turn.emit()
	else:
		no_valid_player_options.emit()

func updateAllCardPositions():
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	paper_sound.play()
	for followPath in card_arc.get_children():
		if not followPath.is_queued_for_deletion():
			create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
			create_tween().tween_property(followPath.get_child(0), "scale", Vector2(1,1), 0.4)
			path_division += pos_incrementer

func changeAllCardAvailability():
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		changeCardAvailibilty(cardNode)

func changeCardAvailibilty(cardNode):
	if isCardUsable(cardNode):
		cardNode.modulate = Color(1, 1, 1)
		cardNode.undraggable = false
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 0), 0.2)
	else:
		cardNode.modulate = Color(0.2, 0.2, 0.2)
		cardNode.undraggable = true
		cardNode.z_index = 0
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 20), 0.2)
