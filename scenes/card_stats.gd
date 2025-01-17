@icon("res://icons/CardStats.svg")
extends TextureRect
class_name CardComponent

@export var card_stats : CardStats

@onready var card = $"."

@onready var card_label = $CardLabel
@onready var icon_image = $IconImage
@onready var description = $Description
@onready var cost_indicator = $Control/MarginContainer/CostIndicator
@onready var cost = $Control/MarginContainer/CostIndicator/Cost
@onready var anims: AnimationPlayer = $AnimationPlayer

const CARD_COST_BLIP = preload("res://art/ui/action_points_meter.png")
const BURN_CARD_COST_BLIP = preload("res://art/ui/burn-card-badge.png")
const DISCARD_BACK = preload("res://art/cards/card-template-back.png")
const BURN_BACK = preload("res://art/cards/card-burn-pile.png")

signal card_used(cardNode : CardComponent)

func _ready():
	updateCardData(card_stats)

func updateCardData(cardStats : CardStats):
	texture = cardStats.card_skin
	card_label.text = cardStats.card_name
	icon_image.texture = cardStats.icon_image
	
	if cardStats.card_description.contains('%'):
		description.text = cardStats.card_description % formatCardStringInterp(false)
	else:
		description.text = cardStats.card_description
		
	if cardStats.one_use:
		cost_indicator.texture = BURN_CARD_COST_BLIP
	else: 
		cost_indicator.texture = CARD_COST_BLIP
	cost.text = str(cardStats.play_cost)

	if cardStats.hide_cost:
		hideCostIndicator()
	
func hideCostIndicator():
	cost_indicator.hide()
	
func hideCardDetails():
	hideCostIndicator()
	icon_image.hide()
	description.hide()
	card_label.hide()

func determine_if_valid_drop_spot(areaInQuestion: Area2D):
	print(areaInQuestion)

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

func burnCard():
	anims.play('burn_card')
	
func discardCard():
	anims.play('discard_card')
