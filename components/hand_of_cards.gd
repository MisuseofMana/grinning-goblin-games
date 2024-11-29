extends Path2D

@onready var card_arc: Path2D = $"."
@onready var paper_sound: AudioStreamPlayer2D = $PaperSound

@export var cards_in_hand : Array[BaseCard] = []
const PRESENTATIONAL_CARD = preload("res://components/cards/presentational_card.tscn")

func _ready():
#	clear out the test cards in the arc
	for arc in card_arc.get_children():
		card_arc.remove_child(arc)
		arc.queue_free()
#	add cards to the hand for every card in current hand
	
	for card in cards_in_hand:
		addCardToHand(card)
	
func set_resource_dictionary(dir):
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.") 
	
		
func add_random_card_to_hand():
	var files = DirAccess.get_files_at("res://components/cards/CardDictionary/BasicCards/")
	var size = files.size()
	var randomNum = (randi() % size)
	var cardResourcePath = load("res://components/cards/CardDictionary/BasicCards/" + files[randomNum])
	addCardToHand(cardResourcePath)

func addCardToHand(cardResource: BaseCard):
	var newFollowNode = PathFollow2D.new()
	var newCard = PRESENTATIONAL_CARD.instantiate()
	newCard.scale = Vector2(0,0)
	newCard.card_data = cardResource
	card_arc.add_child(newFollowNode)
	newFollowNode.add_child(newCard)
	
	#newCard.card_description.text = cardInfo.card_description
	var numberOfCards = card_arc.get_children().size()
	var path_division = 1.0 / (numberOfCards + 1.0)
	var pos_incrementer = path_division
	for followPath in card_arc.get_children():
		create_tween().tween_property(followPath, "progress_ratio", path_division, 0.4)
		create_tween().tween_property(newCard, "scale", Vector2(1,1), 0.4)
		paper_sound.play()
		path_division += pos_incrementer
		
func remove_card_from_path():
	pass
