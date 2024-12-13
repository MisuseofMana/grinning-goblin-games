extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var discard_pile = $DiscardPile
@onready var card_base: Card = $CardArc/CardFollowPath/CardBase

@export var cards_in_hand : Array[CardStats] = []
@export var battle_scene : BattleScene

const CARD = preload("res://components/cards/card.tscn")

var files : Array = []

@export var Player : Unit = null

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
#	add cards to the hand for every card in current hand
	for card in cards_in_hand:
		addCardToHand(card)
		
	for path in ['AttackCards', 'DefenseCards', 'HealCards']:
		var filePath = "res://components/cards/CardDictionary/%s/" % path
		var dir = DirAccess.get_files_at(filePath)
		for card in dir:
			files.append(filePath + card)
		
func add_random_card_to_hand():
	var size = files.size()
	var randomNum = (randi() % size)
	var cardResourcePath = load(files[randomNum])
	addCardToHand(cardResourcePath)

func addCardToHand(cardResource: CardStats):
	var newFollowNode = PathFollow2D.new()
	var newCard = CARD.instantiate()
	newCard.scale = Vector2(0,0)
	newCard.card_stats = cardResource
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	
	newCard.add_to_discard_number.connect(handleDiscardNumber)
	newCard.handle_card_deletion.connect(removeCardAndUpdateHand)
	newCard.card_used.connect(battle_scene.reduceActionPoints)
	newCard.card_interface = self

	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
		create_tween().tween_property(newCard, "scale", Vector2(1,1), 0.4)
		paper_sound.play()
		path_division += pos_incrementer	

func handleDiscardNumber(howMany):
	discard_pile.addNumToDiscard(howMany)

func removeCardAndUpdateHand(cardReference):
	var cardPathFollowNode = cardReference.get_parent()
	cardPathFollowNode.queue_free()
	await cardPathFollowNode.tree_exited
	var followNodes = card_arc.get_children()
	for child in followNodes:
		if child.get_children().size() == 0:
			child.queue_free()
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.2)
		paper_sound.play()
		path_division += pos_incrementer
		
func discardHand():
	for card in card_arc.get_children():
		removeCardAndUpdateHand(card.get_child(0))
		card.get_child(0).anims.play('go_to_discard')
