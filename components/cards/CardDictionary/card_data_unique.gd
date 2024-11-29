extends BasicCard
class_name UniqueCard

var VALID_CHARACTER_TYPES = ['swordsman', 'varlet', 'mage']

func _init()
	base_data["card_belongs_to"] = ''
