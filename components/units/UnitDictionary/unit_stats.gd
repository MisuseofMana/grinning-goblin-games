@tool
extends Resource
class_name	UnitStats

enum VALID_STATS {
	muscle,
	endurance,
	knowledge,
	finesse,
	nuance,
}

@export var stats : Dictionary = {
	"health": 50, # hit points of the player
	"max_health": 50, # max limit for players hp
	"endurance": 4, # influences players max health and defense
	"muscle": 5, # influences players attack power
	"finesse": 3, # influences players dodge and critical
	"knowledge": 0, # influences players magic power 
	"nuance": 0, # influences players magic defense
}

var tokens : Dictionary = {}
