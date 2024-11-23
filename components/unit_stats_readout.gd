extends Node2D

@onready var node_2d = $"."
@onready var unit_type = $UnitType
@onready var unit_level = $UnitLevel
@onready var sprite_hint = $SpriteHint

var level_dots
var storedUnitData

const BLANK_UNIT = preload("res://art/blank-unit.png")

func _ready():
	storedUnitData = Globals.displayUnit
	level_dots  = get_tree().get_nodes_in_group("level_dots")

func _physics_process(delta):
		unit_type.text = Globals.displayUnit.type.capitalize()
		if(Globals.displayUnit.type != '' and Globals.displayUnit.level > 0):
			sprite_hint.texture = UnitSprites.PACKED[Globals.displayUnit.type + str(Globals.displayUnit.level)]

		var i = 1
		for level_dot in level_dots:
			if int(Globals.displayUnit.level) >= i:
				level_dot.animation = 'filled'
			else: 
				level_dot.animation = 'blank'
			i += 1
