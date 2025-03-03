@tool
@icon("res://icons/UnitSprite.svg")
extends Node2D
class_name UnitTarget

@onready var collision = $TwoWayDetection/CollisionShape2D
@onready var unit_sprite = $UnitSprite
@onready var battle_readout = $BattleReadout

@export var anims : AnimationPlayer:
	set(newValue):
		anims = newValue
		update_configuration_warnings()
@export var healthNode : HealthNode :
	set(newValue):
		healthNode = newValue
		update_configuration_warnings()
@export var statsNode : StatsNode :
	set(newValue):
		statsNode = newValue
		update_configuration_warnings()

func _get_configuration_warnings():
	var errors : Array[String] = []
	if not healthNode:
		errors.append("HealthNode export must be assigned.")
	if not statsNode:
		errors.append("StatsNode export must be assigned.")
	if not anims:
		errors.append("Anims export must be assigned.")
	return errors

@export_group("Target Info")
@export var is_friendly : bool = false
@export var is_player : bool = false

func _ready():
	unit_sprite.frame = randi_range(0, unit_sprite.sprite_frames.get_frame_count("idle") - 1)

func die():
	if is_player:
		print('game over')
	else:
		anims.play('death_animation')
		
func takeDamage(howMuch):
	healthNode.take_damage(howMuch)
	
func addToHealth(howMuch):
	healthNode.heal(howMuch)
	
func take_turn():
	print('take_turn is not overwritten')
	pass

func disableTargeting():
	collision.disabled = true

func enableTargeting():
	collision.disabled = false
	
