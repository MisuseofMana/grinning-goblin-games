@tool
@icon("res://icons/CardStats.svg")
extends TextureRect
class_name CardComponent

@export var card_stats : CardStats

@onready var card = $"."
@onready var card_name = $CardName
@onready var icon_image = $IconImage
@onready var description = $Description
@onready var cost_indicator = $CostIndicator
@onready var cost = $CostIndicator/Cost

const CARD_COST_BLIP = preload("res://art/cards/card-cost-blip.png")
const BURN_CARD_COST_BLIP = preload("res://art/cards/burn-card-cost-blip.png")
const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

signal card_used(whichCard)

func _ready():
	updateCardData()
	
func updateCardData():
#	setup card information
	card.texture = card_stats.card_skin
	card_name.text = card_stats.card_name
	icon_image.texture = card_stats.icon_image
	
	if card_stats.card_description.contains('%'):
		description.text = card_stats.card_description % formatCardStringInterp(false)
	else:
		description.text = card_stats.card_description
		
	if card_stats.one_use:
		cost_indicator.texture = BURN_CARD_COST_BLIP
	else: 
		cost_indicator.texture = CARD_COST_BLIP
	cost.text = str(card_stats.play_cost)

	if card_stats.hide_cost:
		hideCostIndicator()
	
func hideCostIndicator():
	cost_indicator.hide()
	
func swapCardBackTexture():
	hideCostIndicator()
	icon_image.hide()
	description.hide()
	card_name.hide()
	card.texture = CARD_TEMPLATE_BACK
	
func runCardEffect(card_owner):
	print('run card effect')
	card_used.emit(card_stats)
	pass
	#if card_stats.targets_self:
		#card_stats.card_effect(card_owner)
	#else:
		#card_stats.card_effect(player)
	#enemy_card_accepted.emit()
		
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
