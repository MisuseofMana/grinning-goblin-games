@tool
extends Node2D
class_name Player

@export var player_stats : PlayerStats
@onready var player_sprite: AnimatedSprite2D = $UnitSprite
@onready var health_bar: ProgressBar = $ReadoutContainer/ProgressBar
@onready var health_num: Label = $ReadoutContainer/Label
@onready var anims: AnimationPlayer = $AnimationPlayer

signal tokens_updated(stats: PlayerStats)
signal check_for_other_enemies()
