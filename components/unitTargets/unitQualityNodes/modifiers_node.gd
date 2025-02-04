extends Node
class_name Modifiers

@export var primaryStatMods : Array[int] = [-2, -1, 0, 1, 3, 4, 5, 7, 9, 10, 13]
@export var secondaryStatMods : Array[int] = [-1, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8]
@export var tokenModifier : Array[int] = [0, 0, 0, 1, 1, 1, 2, 2, 3, 3]

func getPrimaryStatMod(idx):
	return primaryStatMods[idx]
	
func getSecondaryStatMod(idx):
	return secondaryStatMods[idx]
	
func getTokenModifier(idx):
	return primaryStatMods[idx]
