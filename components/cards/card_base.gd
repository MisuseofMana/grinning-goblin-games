@icon("res://icons/CardStats.svg")
extends TextureRect
class_name CardComponent

@onready var card_details = $CardDetails
@onready var description = $CardDetails/Description
@onready var cost_indicator = $Control/MarginContainer/CostIndicator
@onready var cost = $Control/MarginContainer/CostIndicator/Cost
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var modifiers = $Modifiers
@onready var detection = $TwoWayDetection/CollisionShape2D

@export var card_owner : UnitTarget

@export_group("Card Stats")
@export var is_burn_card : bool = false
@export var play_cost : int = 1
@export var can_use_to_respond : bool = false
@export var hide_cost_indicator : bool = false
@export var targets_self : bool = false
@export var base_value : int = 0
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var primary_stat : String
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var secondary_stat : String

@export var card_is_draggable : bool = true

var debuff_value = 0

const BURN_CARD_COST_BLIP = preload("res://art/ui/burn-card-badge.png")
const DISCARD_BACK = preload("res://art/cards/card-template-back.png")
const BURN_BACK = preload("res://art/cards/card-burn-pile.png")

signal card_used(cardNode : CardComponent)

func _ready():
	if not card_is_draggable:
		detection.disabled = true

func updateCardData():
	if description.text.contains('%'):
		description.text = description.text % formatCardStringInterp(false)
	if is_burn_card:
		cost_indicator.texture = BURN_CARD_COST_BLIP
	if hide_cost_indicator:
		hideCostIndicator()
	cost.text = str(play_cost)
	
func hideCostIndicator():
	cost_indicator.hide()
	
func hideCardDetails():
	hideCostIndicator()
	card_details.hide()
		
func determine_if_valid_drop_spot(areaInQuestion: Area2D):
	var targetNode : UnitTarget = areaInQuestion.owner
	if targetNode:
		pass

func formatCardStringInterp(noBBCode):
	var color
	var adjustedValue = calculate_adj_value()
	
	if adjustedValue < base_value:
		color = Color(1,0,0).to_html()
	elif base_value == adjustedValue:
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

func calculate_adj_value():
	var modifierValue : int = base_value
	if primary_stat:
		modifierValue += modifiers.getPrimaryStatMod(card_owner.stats[primary_stat])
		modifierValue = clampi(modifierValue, 1, 999)
	if secondary_stat:
		modifierValue += modifiers.getSecondaryStatMod(card_owner.stats[secondary_stat])
		modifierValue = clampi(modifierValue, 1, 999)
	return modifierValue
	
func calculate_adj_token_value():
	var modifierValue = base_value
	if primary_stat:
		modifierValue += modifiers.getTokenModifier(card_owner.stats[primary_stat])
	modifierValue = clampi(modifierValue, 0, 999)
	return modifierValue
	
func addToDebuff(howMuch : int):
	debuff_value += howMuch
