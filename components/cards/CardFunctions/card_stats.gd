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

@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var relevant_stats : Array[String] = []

@export var card_image : Texture2D

#meant to be overwritten in extended CardStats scripts 
func card_effect(_target_unit: Unit, _owner_unit: UnitStats):
	print('no overwritten card_effect function!')
	pass
