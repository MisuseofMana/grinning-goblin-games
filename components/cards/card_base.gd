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
@onready var make_card_draggable = $MakeCardDraggable

@onready var effect_node = $CardEffect

@export var card_owner : UnitTarget
@export var card_stats: CardStats

@export var card_is_draggable : bool = true

var debuff_value : int = 0
const BURN_CARD_BADGE = preload("res://art/ui/burn-card-badge.png")
const DISCARD_BACK = preload("res://art/cards/card-template-back.png")
const BURN_BACK = preload("res://art/cards/card-burn-pile.png")

signal cards_sent_to_graveyard(cardNode : CardComponent)

func updateCardData():
	if description.text.contains('%'):
		description.text = description.text % formatCardStringInterp(false)
	if card_stats.is_burn_card:
		cost_indicator.texture = BURN_CARD_BADGE
	if card_stats.hide_cost_indicator:
		hideCostIndicator()
	cost.text = str(card_stats.play_cost)
	
func hideCostIndicator():
	cost_indicator.hide()
	
func hideCardDetails():
	hideCostIndicator()
	card_details.hide()
	
func swap_to_burn_back():
	hideCardDetails()
	texture = BURN_BACK
	
func swap_to_discard_back():
	hideCardDetails()
	texture = DISCARD_BACK
	
func formatCardStringInterp(noBBCode):
	var color
	var adjustedValue = calculate_adj_value()
	
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
	go_to_discard_area()
	
func discardCard():
	anims.play('discard_card')
	go_to_discard_area()

func go_to_discard_area():
	make_card_draggable.undraggable = true
	detection.disabled = true
	await get_tree().create_tween().tween_property(self, "global_position", Vector2(1100, 480), 0.6).finished
	cards_sent_to_graveyard.emit(self)

func reduce_ap_by_card_cost():
	GameState.ap_reduced.emit(card_stats.play_cost)
	
func calculate_adj_value():
	var modifierValue : int = card_stats.base_value
	if card_stats.primary_stat:
		modifierValue += modifiers.getPrimaryStatMod(card_owner.statsNode[card_stats.primary_stat])
		modifierValue = clampi(modifierValue, 1, 999)
	if card_stats.secondary_stat:
		modifierValue += modifiers.getSecondaryStatMod(card_owner.statsNode[card_stats.secondary_stat])
		modifierValue = clampi(modifierValue, 1, 999)
	return modifierValue
	
func calculate_adj_token_value():
	var modifierValue = card_stats.base_value
	if card_stats.primary_stat:
		modifierValue += modifiers.getTokenModifier(card_owner.statsNode[card_stats.primary_stat])
	modifierValue = clampi(modifierValue, 0, 999)
	return modifierValue
	
func addToDebuff(howMuch : int):
	debuff_value += howMuch
