@tool
extends Resource
class_name	UnitStats

@export var health : int
@export var max_health: int
@export var attack : int
@export var magicAttack: int
@export var defense : int
@export var magicDefense : int

enum VALID_STATS {
	muscle,
	endurance,
	knowledge,
	finesse,
	nuance,
}

@export var counters : Array[CounterStats] = []

@export_enum('idle', 'attack', 'magic-attack', 'hurt') var animation_names : Array[String] = []
@export_enum ('player', 'goblin') var character_type : String
@export var is_self : bool

var unit : Unit = null

var ARMOR = preload("res://components/counters/CounterTypes/armor.tres")
var WARD = preload("res://components/counters/CounterTypes/ward.tres")

signal health_reduced()
signal counters_changed(counterResource)

# Hoping to refactor this all to operate more locally in this script
# Right now the cards trigger effects in the unit which communicate to the counters
# I should be able to refactor it to be less confusing and rely more on signals?

func run_card_effects(card_effects):
	for effect in card_effects:
		match effect.name:
			'phys_defense': addPhysDefense()
			'magic_damage': takeMagicDamage(effect.value)
			'magic_defense': addMagicDefense()
			'heal': heal(effect.value)
		
func takeMagicDamage(value):
	var magicDamageFormula = value - defense
	
func addPhysDefense():
	ARMOR.value = defense
	counters_changed.emit(ARMOR)

func addMagicDefense():
	WARD.value = magicDefense
	counters_changed.emit(WARD)

func heal(value):
	var remainingPoints = value
	while remainingPoints > 0:
		health += 1
		remainingPoints -= 1
	
