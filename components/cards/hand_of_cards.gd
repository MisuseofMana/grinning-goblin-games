extends Node2D
class_name HandOfCards

@onready var hand_of_cards = $"."
@onready var card_arc = $CardArc
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound
@onready var discard_pile = $DiscardPile
@onready var card_base: Card = $CardArc/CardFollowPath/CardBase
@onready var action_points_counter = $Sprite2D/ActionPointsCounter
@onready var gpu_particles_2d = $Sprite2D/GPUParticles2D

@export var cards_in_hand : Array[CardStats] = []
@export var PlayerUnit : Unit :
	set(value):
		PlayerUnit = value
		var ap : int = 0
		if PlayerUnit && is_node_ready():
			ap = PlayerUnit.unit_stats.action_points
			action_points_counter.text = str(ap)
			if ap <= 0:
				ran_out_of_action_points.emit()

const CARD = preload("res://components/cards/card.tscn")

signal ran_out_of_action_points()
signal card_used(card: Card)

var files : Array = []

func _ready():
	#action_points_counter.text = str(PlayerUnit.unit_stats.action_points)
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
#	add cards to the hand for every card in current hand
	for card in cards_in_hand:
		addCardToHand(card)
		
	for path in ['AttackCards', 'DefenseCards', 'HealCards']:
		var filePath = "res://components/cards/CardDictionary/Player/%s/" % path
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

func removeCardAndUpdateHand(cardReference : Card):
	var cardPathFollowNode = cardReference.get_parent()
	cardPathFollowNode.queue_free()
	await cardPathFollowNode.tree_exited
	for child in card_arc.get_children():
		if child.get_children().size() == 0:
			cardReference.card_display.hide_indicator()
			cardReference.anims.play('go_to_discard')
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.2)
		paper_sound.play()
		path_division += pos_incrementer
		
func discardHand():
	for card in card_arc.get_children():
		create_tween().tween_property(card, "global_position", Vector2(606, 378), 0.4)
		card.get_child(0).anims.play("go_to_discard")
		
func freeCardFollowNode(cardFollow : PathFollow2D):
	print(cardFollow)
	print('free card node')
	cardFollow.queue_free()
