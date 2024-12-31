@tool
extends Node2D
class_name Unit

@export var unit_stats : UnitStats
@onready var unit_sprite: AnimatedSprite2D = $UnitSprite
@onready var health_bar: ProgressBar = $ReadoutContainer/ProgressBar
@onready var health_num: Label = $ReadoutContainer/Label
@onready var anims: AnimationPlayer = $AnimationPlayer

signal tokens_updated(unit_stats: UnitStats)
signal check_for_other_enemies()
