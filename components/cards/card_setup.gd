extends Control

@onready var rich_card_description: RichTextLabel = $RichCardDescription
@onready var card_image_slot: TextureRect = $CardImageSlot
@onready var card_name: Label = $CardName
@onready var card_cost_label: Label = $CostIndicator/CardCostLabel

@export var card_stats : CardStats

const PLAYER = preload("res://components/units/UnitDictionary/UnitTypes/player.tres")

func setCardData():
	card_name.text = card_stats.readable_name
	rich_card_description.text = card_stats.card_description % GameLogic.calculateCardCost(card_stats, PLAYER, false)
	card_image_slot.texture = card_stats.card_image 
	card_cost_label.text = str(card_stats.play_cost)
