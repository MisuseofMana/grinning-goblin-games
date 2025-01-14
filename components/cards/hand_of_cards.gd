extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var ap_particles = $Sprite2D/GPUParticles2D

@export var battleScene : BattleScene
@export var player : UnitSprite

const CARD = preload("res://components/cards/card.tscn")

var max_action_points : int = 3
var action_points_remaining : int = 3

signal end_player_turn()
signal no_valid_player_options()
signal action_points_changed(byHowMany : int)
signal card_discarded(cardStats : CardStats)
signal card_burned(cardStats : CardStats)

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
	
func refreshActionPoints():
	action_points_remaining = max_action_points
		
func add_random_card_to_hand():
	pass
	#drawCards(1)

func playerTurnSetup():
	await discardHand()
	#drawCards(hand_size)

func addCardToHand(cardStats: CardStats):
	var newFollowNode = PathFollow2D.new()
	var newCard = CARD.instantiate()
	newCard.scale = Vector2(1,1)
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	newCard.card_stats = cardStats
	newCard.card_used.connect(handleCardUse)
	newCard.tree_exited.connect(updateAllCardPositions)
	newCard.tree_exited.connect(checkForValidPlayerActions)
	

	updateAllCardPositions()
	changeCardAvailibilty(newCard)
	
func discardHand():
	for followPath in card_arc.get_children():
		await self.get_tree().create_timer(0.2).timeout
		putCardInDiscard(followPath.get_child(0))

func putCardInDiscard(card : CardComponent):
	var card_stats : CardStats = card.card_stats
	card.anims.play('discard')
	create_tween().tween_property(card, "global_position", Vector2(579,342), 0.6)
	card.discardCard()
	
func putCardInBurnPile(card : CardComponent):
	var card_stats : CardStats = card.card_stats
	card.anims.play('burn')
	create_tween().tween_property(card, "global_position", Vector2(600,315), 0.6)
	card.burnCard()
	
func isCardUsable(card : CardComponent):
	if card.card_stats.play_cost > action_points_remaining:
		return false
	var canUseAsResponse = not battleScene.players_turn and card.card_stats.can_use_to_respond
	var canUseOnTurn = not card.card_stats.can_use_to_respond and battleScene.players_turn
	return canUseAsResponse or canUseOnTurn or card.card_stats.can_use_whenever
	
func handleCardUse(card: CardComponent):
	var card_stats : CardStats = card.card_stats
	action_points_changed.emit(card_stats.play_cost)
	ap_particles.emitting = true
	
	if card_stats.one_use:
		putCardInBurnPile(card)
	else:
		putCardInDiscard(card)
	
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

func changeCardAvailibilty(cardNode: CardComponent):
	if isCardUsable(cardNode):
		cardNode.modulate = Color(1, 1, 1)
		cardNode.undraggable = false
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 0), 0.2)
	else:
		cardNode.modulate = Color(0.2, 0.2, 0.2)
		cardNode.undraggable = true
		cardNode.z_index = 0
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 20), 0.2)
