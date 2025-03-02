extends Node2D
class_name CardBattleInterface

@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
		
func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()

func addCardsToHand(cardScenes: Array[PackedScene]):
	for scene in cardScenes:
		var newFollowNode = PathFollow2D.new()
		var newCard : CardComponent = scene.instantiate()
		card_arc.add_child(newFollowNode)
		newFollowNode.add_child(newCard)
		newCard.updateCardData.call_deferred()
		newCard.cards_sent_to_graveyard.connect(free_card)
		newCard.tree_exited.connect(updateAllCardPositions)
		newCard.tree_exited.connect(checkForValidPlayerActions)
		changeCardAvailibilty(newCard)

	updateAllCardPositions()

func free_card(card : CardComponent):
	var coercedArray : Array[CardComponent]
	coercedArray.append(card)
	if card.is_burn_card:
		add_to_burn_pile.emit(coercedArray)
	else:
		add_to_discard_pile.emit(coercedArray)
	for followPath in card_arc.get_children():
		if followPath.get_child(0) == card:
			followPath.queue_free()

func discardHand():
	var current_hand = card_arc.get_children()
	current_hand.reverse()
	for followPath in current_hand:
		var cardNode : CardComponent = followPath.get_child(0)
		await self.get_tree().create_timer(0.1).timeout
		cardNode.discardCard()
	finished_hand_discard.emit()
	
func isCardUsable(card : CardComponent):
	if card.play_cost > action_points_remaining:
		return false
	var canUseAsResponse = not battleScene.players_turn and card.can_use_to_respond
	var canUseOnTurn = not card.can_use_to_respond and battleScene.players_turn
	return canUseAsResponse or canUseOnTurn or card.can_use_whenever
		
func checkForValidPlayerActions():
	var can_play_a_card = false
	if action_points_remaining <= 0:
		if battleScene.players_turn:
			end_player_turn.emit()
	for followNode in card_arc.get_children():
		if not followNode.is_queued_for_deletion():
			var cardNode = followNode.get_child(0)
			if isCardUsable(cardNode) == true:
				can_play_a_card = true
	if battleScene.players_turn and not can_play_a_card:
		end_player_turn.emit()

func updateAllCardPositions():
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		if not followPath.is_queued_for_deletion():
			paper_sound.play()
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
