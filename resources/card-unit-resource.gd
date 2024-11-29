@tool
extends Resource
class_name	CardUnitStats

@export var health : int
@export var attack : int
@export var defense : int

@export_enum('idle', 'attack', 'magic-attack', 'hurt') var animation_names : Array[String] = []
@export_enum ('player', 'goblin') var character_type : String

@export_enum('self', 'enemy') var target_type : String

func takeDamage(damage):
	health -= damageFormula(damage)
	
func damageFormula(damage):
	var remainingPoints = damage - defense
	while remainingPoints > 0:
		health -= 1
		remainingPoints -= 1

func heal(value):
	var remainingPoints = value
	while remainingPoints > 0:
		health += 1
		remainingPoints -= 1
