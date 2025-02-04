extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound

@export var battleScene : BattleScene
@export var player : UnitTarget

var max_action_points : int = 3
var action_points_remaining : int = 3

signal end_player_turn()
signal no_valid_player_options()
signal action_points_changed(byHowMany : int)
signal card_discarded(cardStats : Resource)
signal card_burned(cardStats : Resource)

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
	
func refreshActionPoints():
	action_points_remaining = max_action_points

func playerTurnSetup():
	await discardHand()
	player.deck.draw_hand_size()

func addCardToHand(cardComponent: Resource):
	var newFollowNode = PathFollow2D.new()
	var newCard : CardComponent = cardComponent.instantiate()
	newCard.card_owner = player
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	newCard.updateCardData.call_deferred()
	newCard.card_used.connect(handleCardUse)
	newCard.tree_exited.connect(updateAllCardPositions)
	newCard.tree_exited.connect(checkForValidPlayerActions)

	updateAllCardPositions()
	changeCardAvailibilty(newCard)
	
func discardHand():
	for followPath in card_arc.get_children():
		var cardNode : CardComponent = followPath.get_child(0)
		await self.get_tree().create_timer(0.1).timeout
		putCardInDiscard(cardNode)

func putCardInDiscard(card : CardComponent):
	card.anims.play('discard')
	create_tween().tween_property(card, "global_position", Vector2(579,342), 0.6)
	card.discardCard()
	
func putCardInBurnPile(card : CardComponent):
	card.anims.play('burn')
	create_tween().tween_property(card, "global_position", Vector2(600,315), 0.6)
	card.burnCard()
	
func isCardUsable(card : CardComponent):
	if card.play_cost > action_points_remaining:
		return false
	var canUseAsResponse = not battleScene.players_turn and card.can_use_to_respond
	var canUseOnTurn = not card.can_use_to_respond and battleScene.players_turn
	return canUseAsResponse or canUseOnTurn or card.can_use_whenever
	
func handleCardUse(card: CardComponent):
	action_points_changed.emit(card.play_cost)
	
	if card.one_use:
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
		cardNode.get_node("MakeCardDraggable").undraggable = false
		#create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 0), 0.2)
	else:
		cardNode.modulate = Color(0.2, 0.2, 0.2)
		cardNode.get_node("MakeCardDraggable").undraggable = false
		cardNode.z_index = 0
		#create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 20), 0.2)
