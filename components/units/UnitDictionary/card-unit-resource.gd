@tool
extends Resource
class_name	UnitStats

@export var health : int
@export var max_health: int
@export var attack : int
@export var defense : int
@export var magicDefense: int
@export_enum('idle', 'attack', 'magic-attack', 'hurt') var animation_names : Array[String] = []
@export_enum ('player', 'goblin') var character_type : String
@export var is_self : bool

var unit : Unit = null

var ARMOR = preload("res://components/counters/CounterTypes/armor.tres")
var WARD = preload("res://components/counters/CounterTypes/ward.tres")

signal health_reduced()
signal counters_changed(counterResource)

func create_timer(timerLength):
	return unit.get_tree().create_timer(timerLength).timeout

func run_card_effects(card_effects):
	for effect in card_effects:
		match effect.name:
			'phys_damage': takePhysDamage(effect.value)
			'phys_defense': addPhysDefense()
			'magic_damage': takeMagicDamage(effect.value)
			'magic_defense': addMagicDefense()
			'heal': heal(effect.value)

func healthTickDown(amountToReduceHealthBy):
	var remainingPoints = amountToReduceHealthBy
	while remainingPoints > 0:
		await create_timer(0.1)
		remainingPoints -= 1
		health_reduced.emit()

func takePhysDamage(value):
	var physDamageFormula = value - defense
	healthTickDown(physDamageFormula)
		
func takeMagicDamage(value):
	var magicDamageFormula = value - defense
	healthTickDown(magicDamageFormula)
	
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
