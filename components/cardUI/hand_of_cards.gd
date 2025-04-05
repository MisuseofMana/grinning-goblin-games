extends Node2D
class_name CardBattleHud

@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound

@export var deckPileNode : DeckPile
@export var discardPileNode: DiscardPile
@export var actionPointsNode: ActionPoints
@onready var deck_location = $DeckLocation
@onready var anims = $AnimationPlayer

const CARD_BASE = preload("res://components/cards/card_base.tscn")

signal end_player_turn
signal start_player_turn

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
		newCard.cards_sent_to_graveyard.connect(discard_card)
		newCard.cards_sent_to_burn_pile.connect(burn_card)
		newCard.ap_reduced.connect(reduce_ap)
		newCard.tree_exited.connect(updateAllCardPositions)
		#newCard.check_for_valid_moves.connect(checkForValidPlayerActions)
		changeCardAvailibilty(newCard)
	updateAllCardPositions()

func discard_card(card : CardComponent):
	var card_stats = card.card_stats
	var coercedArray : Array[CardStats] = [card_stats]
	discardPileNode.add_cards_to_discard(coercedArray)
	free_card_node(card)
	
func burn_card(card : CardComponent):
	var card_stats = card.card_stats
	var coercedArray : Array[CardStats] = [card_stats]
	discardPileNode.add_cards_to_burn(coercedArray)
	free_card_node(card)

func free_card_node(card: CardComponent):
	for followPath in card_arc.get_children():
		if followPath.get_child(0) == card:
			followPath.queue_free()
	updateAllCardPositions()
	changeAllCardAvailability()

func discardHand():
	var current_hand : Array[PathFollow2D]
	for followPath in card_arc.get_children():
		if not followPath.is_queued_for_deletion():
			current_hand.append(followPath)
	current_hand.reverse()
	for path in current_hand:
		var cardNode : CardComponent = path.get_child(0)
		await self.get_tree().create_timer(0.1).timeout
		cardNode.discardCard()
	start_player_turn.emit()
	
func isCardUsable(cardStats : CardStats):
	if cardStats.play_cost > actionPointsNode.action_points:
		return false
	var canUseAsResponse = not SaveData.players_turn and cardStats.can_use_to_respond
	var canUseOnTurn = not cardStats.can_use_to_respond and SaveData.players_turn
	return canUseAsResponse or canUseOnTurn or cardStats.can_use_whenever
		
func checkForValidPlayerActions():
	var can_play_a_card = false
	if actionPointsNode.action_points <= 0:
		if SaveData.players_turn:
			end_player_turn.emit()
			return
		for followNode in card_arc.get_children():
			if not followNode.is_queued_for_deletion():
				var cardNode = followNode.get_child(0)
				if isCardUsable(cardNode.card_stats):
					can_play_a_card = true
		if SaveData.players_turn and not can_play_a_card:
			end_player_turn.emit()

func updateAllCardPositions():
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		if not followPath.is_queued_for_deletion():
			var cardNode : CardComponent = followPath.get_child(0)
			var draggableNode : MakeCardDraggable = cardNode.make_card_draggable
			if not draggableNode.is_dragging:
				paper_sound.play()
				create_tween().tween_property(followPath, "progress_ratio", path_division, 0.2)
				create_tween().tween_property(followPath.get_child(0), "scale", Vector2(1,1), 0.2)
				path_division += pos_incrementer

func changeAllCardAvailability():
	for followNode in card_arc.get_children():
		var cardNode = followNode.get_child(0)
		changeCardAvailibilty(cardNode)

func changeCardAvailibilty(cardNode: CardComponent):
	if isCardUsable(cardNode.card_stats):
		cardNode.modulate = Color(1, 1, 1)
		cardNode.make_card_draggable.make_draggable()
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, -264), 0.2)
	else:
		cardNode.modulate = Color(0.2, 0.2, 0.2)
		cardNode.make_card_draggable.make_undraggable()
		cardNode.z_index = 0
		create_tween().tween_property(cardNode, "position", Vector2(cardNode.position.x, -240), 0.2)

func reduce_ap(howMuch: int):
	actionPointsNode.reduce_ap_by(howMuch)

func restock_deck_clear_discard():
	anims.play('restock_deck')
	var discardCards = discardPileNode.discard_pile
	var existingDeck = deckPileNode.deck_pile
	var newDeck : Array[CardStats]
	newDeck.append_array(discardCards)
	newDeck.append_array(existingDeck)
	deckPileNode.deck_pile = newDeck
	discardPileNode.discard_pile = []

func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'restock_deck':
		deckPileNode.draw_hand_size()
