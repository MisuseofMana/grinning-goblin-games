extends Control
class_name CardImage

@export var card_stats : CardStats : 
	set(value):
		card_stats = value
		setCardData(value)
@export var hideCost : bool = false

const PLAYER = preload("res://components/units/UnitDictionary/UnitTypes/player.tres")
const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

func setCardData(card_info: CardStats):
	$CardImage.texture = card_info.card_skin
	$Name.text = card_info.readable_name
	if card_info.card_description.contains('%'):
		$Description.text = card_info.card_description % GameLogic.calculateCardCost(card_info, PLAYER, false)
	else:
		$Description.text = card_info.card_description

	if not hideCost:
		$IconImage.texture = card_info.card_image 
		$CostIndicator/Cost.text = str(card_info.play_cost)
	else:
		hideCostIndicator()
	
func hideCostIndicator():
	$CostIndicator.hide()
	
func swapCardBackTexture():
	hideCostIndicator()
	$IconImage.hide()
	$Description.hide()
	$Name.hide()
	$CardImage.texture = CARD_TEMPLATE_BACK
