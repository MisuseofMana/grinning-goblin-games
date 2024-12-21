extends Resource
class_name CardStats

@export var card_name : String
@export var readable_name : String
@export var one_use : bool
@export var targets_self : bool
@export var base_value : int
@export var play_cost : int
@export var card_description : String
@export var tool_tip : String
@export var debuff_value : int = 0

@export var can_use_to_respond : bool

@export var card_owner : UnitStats

@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var primary_stat : String
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var secondary_stat : String

@export var card_image : Texture2D
@export var card_skin : Texture2D = preload("res://art/cards/card_art/card-template.png")

var primaryStatMods = [-3, -1, 0, 1, 3, 4, 5, 7, 9, 10, 13]
var secondaryStatMods = [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]
var tokenModifier = [0, 0, 0, 1, 1, 2, 2, 3, 3, 4]

#meant to be overwritten in extended CardStats scripts 
func card_effect(_target):
	print('no overwritten card_effect function!')
	pass
	
func calculate_adj_value():
	var modifierValue : int = base_value
	if primary_stat:
		print(primaryStatMods[card_owner.stats[primary_stat]])
		modifierValue += primaryStatMods[card_owner.stats[primary_stat]]
	if secondary_stat:
		print(secondaryStatMods[card_owner.stats[secondary_stat]])
		modifierValue += secondaryStatMods[card_owner.stats[secondary_stat]]
	if debuff_value:
		modifierValue -= debuff_value
	return modifierValue
	
func calculate_adj_token_value():
	var modifierValue = base_value
	return modifierValue
	
func reduceBaseValue():
	base_value -= 1
