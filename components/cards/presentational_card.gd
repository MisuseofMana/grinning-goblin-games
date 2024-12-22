extends Control
class_name CardImage

@export var card_stats : CardStats : 
	set(value):
		card_stats = value
		setCardData(value)
@export var hideCost : bool = false
@export var active_enemy : Unit
@export var player : Unit

signal enemy_card_accepted()

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

func formatCardStringInterp(noBBCode):
	var color
	var adjustedValue = card_stats.calculate_adj_value()
	
	if adjustedValue < card_stats.base_value:
		color = Color(1,0,0).to_html()
	elif card_stats.base_value == adjustedValue:
		color = Color(0,0,0).to_html()
	else: 
		color = Color(0,1,0.1).to_html()
	
	if noBBCode:
		return adjustedValue
	else:
		return "[color=%s]%s[/color]" % [color, str(adjustedValue)]

func setCardData(card_info: CardStats):
	$CardImage.texture = card_info.card_skin
	$IconImage.texture = card_info.card_image
	$Name.text = card_info.readable_name
	if card_info.card_description.contains('%'):
		$Description.text = card_info.card_description % formatCardStringInterp(false)
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
	
func runCardEffect():
	if card_stats.targets_self:
		card_stats.card_effect(active_enemy)
	else:
		card_stats.card_effect(player)
	enemy_card_accepted.emit()
	
func changeActiveEnemy(toWho):
	active_enemy = toWho
	
