class_name CardStats extends Resource

@export_group('Card Logic')
@export var accepts_cards: bool = false
@export var is_burn_card : bool = false
@export var can_use_to_respond : bool = false
@export var can_use_whenever : bool = false
@export var enemy_card : bool = false
@export var targets_self : bool = false

@export_group('Card Stats')
@export var play_cost : int = 1
@export var base_value : int = 0
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var primary_stat : String
@export_enum('muscle', 'endurance', 'knowledge', 'finesse', 'nuance') var secondary_stat : String

@export_group('Card Details')
@export var name : String
@export_multiline var description : String
@export var card_image : Texture2D
@export var card_back : Texture2D = preload("res://art/cards/card-template-back.png")
@export var card_front : Texture2D = preload("res://art/cards/card_art/card-template.png")

@export_group('Card Effect')
@export var card_effect : GDScript
