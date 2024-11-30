extends Resource
class_name CardStats

enum VALID_STATS {
	muscle,
	endurance,
	knowledge,
	finesse,
	nuance,
}

@export var card_name : String
@export var readable_name : String
@export var one_use : bool
@export var targets_self : bool
@export var base_value : int
@export var play_cost : int
@export var card_description : String
@export var tool_tip : String
@export var relevant_stats: Array[VALID_STATS]
@export var card_image : Texture2D

@export_enum ('phys_damage', 'magic_damage', 'heal', 'phys_defense', 'magic_defense') var effect_types : Array[String]
