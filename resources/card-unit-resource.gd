
@tool
extends Resource
class_name	CardUnitStats

@export var health : int
@export var attack : int
@export var defense : int
@export_enum('idle', 'attack', 'magic-attack', 'hurt') var animation_names : Array[String] = []
@export_enum ('player', 'goblin') var character_type : String
