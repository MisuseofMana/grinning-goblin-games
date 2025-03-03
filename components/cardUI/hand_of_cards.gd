extends Node2D
class_name CardBattleHud

@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound

@export var deckPileNode : DeckPile
@export var discardPileNode: DiscardPile
@export var actionPointsNode: ActionPoints
@export var addDiscardToDeckSpawnNode : Node2D

const CARD_BASE = preload("res://components/cards/card_base.tscn")

signal end_player_turn

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()

func addCardsToHand(cardStats: Array[CardStats]):
	for statFile in cardStats:
		var newCard : CardComponent = CARD_BASE.instantiate()
		newCard.card_stats = statFile
		var newFollowNode = PathFollow2D.new()
		card_arc.add_child(newFollowNode)
		newFollowNode.add_child(newCard)
		newCard.updateCardData.call_deferred()
		newCard.cards_sent_to_graveyard.connect(free_card)
		newCard.tree_exited.connect(updateAllCardPositions)
		newCard.tree_exited.connect(checkForValidPlayerActions)
		changeCardAvailibilty(newCard)

	updateAllCardPositions()

func free_card(card : CardStats):
	var coercedArray : Array[CardStats]
	coercedArray.append(card)
	if card.is_burn_card:
		discardPileNode.add_cards_to_burn(coercedArray)
	else:
		discardPileNode.add_cards_to_discard(coercedArray)
	for followPath in card_arc.get_children():
		if followPath.get_child(0) == card:
			followPath.queue_free()

func discardHand():
	var current_hand = card_arc.get_children()
	current_hand.reverse()
	for followPath in current_hand:
		var cardNode : CardComponent = followPath.get_child(0)
		await self.get_tree().create_timer(0.2).timeout
		cardNode.discardCard()
	
func isCardUsable(card : CardStats):
	if card.play_cost > SaveData.action_points:
		return false
	var canUseAsResponse = not SaveData.playersTurn and card.can_use_to_respond
	var canUseOnTurn = not card.can_use_to_respond and SaveData.players_turn
	return canUseAsResponse or canUseOnTurn or card.can_use_whenever
		
func checkForValidPlayerActions():
	var can_play_a_card = false
	if SaveData.saved_action_points <= 0:
		if SaveData.players_turn:
			end_player_turn.emit()
	for followNode in card_arc.get_children():
		if not followNode.is_queued_for_deletion():
			var cardNode = followNode.get_child(0)
			if isCardUsable(cardNode) == true:
				can_play_a_card = true
	if SaveData.players_turn and not can_play_a_card:
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
	if isCardUsable(cardNode.card_stats):
		cardNode.modulate = Color(1, 1, 1)
		cardNode.get_node("MakeCardDraggable").undraggable = false
		#create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 0), 0.2)
	else:
		cardNode.modulate = Color(0.2, 0.2, 0.2)
		cardNode.get_node("MakeCardDraggable").undraggable = false
		cardNode.z_index = 0
		#create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, 20), 0.2)
