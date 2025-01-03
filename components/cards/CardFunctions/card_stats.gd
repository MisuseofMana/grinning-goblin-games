extends Resource
class_name CardStats

@export var card_name : String
@export var one_use : bool
@export var targets_self : bool
@export var base_value : int
@export var play_cost : int
@export var card_description : String
@export var tool_tip : String
@export var debuff_value : int = 0
@export var hide_cost : bool = false

@export var can_use_whenever : bool
@export var can_use_to_respond : bool
@export var card_owner : UnitStats

enum CardTypes {PHYS_DAMAGE, MAG_DAMAGE, DEFENSE, WARD, HEAL, TOKEN}

@export var accepts_card_types : Array[CardTypes] = []
@export var card_type : CardTypes

@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var primary_stat : String
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var secondary_stat : String

@export var icon_image : Texture2D
@export var card_skin : Texture2D = preload("res://art/cards/card_art/card-template.png")

signal values_changed()

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
		modifierValue += primaryStatMods[card_owner.stats[primary_stat]]
		modifierValue = clampi(modifierValue, 1, 999)
	if secondary_stat:
		modifierValue += secondaryStatMods[card_owner.stats[secondary_stat]]
		modifierValue = clampi(modifierValue, 1, 999)
	if debuff_value:
		modifierValue -= debuff_value
		modifierValue = clampi(modifierValue, 0, 999)
	return modifierValue
	
func calculate_adj_token_value():
	var modifierValue = base_value
	if primary_stat:
		modifierValue += tokenModifier[card_owner.stats[primary_stat]]
	modifierValue = clampi(modifierValue, 0, 999)
	return modifierValue
	
func addToDebuff():
	debuff_value += 1
	values_changed.emit(self)
