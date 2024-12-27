@icon("res://icons/StatsNode.svg")
extends Node
class_name StatsNode

@export var muscle : int = 0
@export var finesse : int = 0
@export var endurance : int = 0
@export var knowledge : int = 0
@export var nuance : int = 0

@export var debuffs : Dictionary = {}

@export var is_friendly : bool

var primaryStatMods = [-3, -1, 0, 1, 3, 4, 5, 7, 9, 10, 13]
var secondaryStatMods = [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]
var tokenModifier = [0, 0, 0, 1, 1, 2, 2, 3, 3, 4]

func getPrimaryStatMod(idx):
	return primaryStatMods[idx]
	
func getSecondaryStatMod(idx):
	return secondaryStatMods[idx]
