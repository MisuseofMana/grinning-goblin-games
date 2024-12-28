extends Node
class_name Modifiers

var primaryStatMods = [-3, -1, 0, 1, 3, 4, 5, 7, 9, 10, 13]
var secondaryStatMods = [-2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8]
var tokenModifier = [0, 0, 0, 1, 1, 2, 2, 3, 3, 4]

func getPrimaryStatMod(idx):
	return primaryStatMods[idx]
	
func getSecondaryStatMod(idx):
	return secondaryStatMods[idx]
	
func getTokenModifier(idx):
	return primaryStatMods[idx]
