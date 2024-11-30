@tool
extends Resource
class_name	UnitStats

@export var health : int
@export var attack : int
@export var defense : int
@export var magicDefense: int

@export var unit_effects : Array[CardStats] = []

@export_enum('idle', 'attack', 'magic-attack', 'hurt') var animation_names : Array[String] = []
@export_enum ('player', 'goblin') var character_type : String

@export var is_self : bool

func run_card_effects(card_effects):
	for effect in card_effects:
		print(effect)
		match effect.name:
			'phys_damage': takePhysDamage(effect.value)
			'phys_defense:': addPhysDefense(effect.value)
			'magic_damage': takeMagicDamage(effect.value)
			'magic_defense': addMagicDefense(effect.value)
			'heal': heal(effect.value)
	

func takePhysDamage(value):
	var remainingPoints = value - defense
	while remainingPoints > 0:
		health -= 1
		remainingPoints -= 1
		
func takeMagicDamage(value):
	var remainingPoints = value - defense
	while remainingPoints > 0:
		health -= 1
		remainingPoints -= 1

func addPhysDefense(value):
	print('add phys defense')
	print(value)

func addMagicDefense(value):
	print('add magic defense')
	print(value)

func heal(value):
	var remainingPoints = value
	while remainingPoints > 0:
		health += 1
		remainingPoints -= 1

func handle_effects():
	for effect in unit_effects:
		effect.card_effect(self)
