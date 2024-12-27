@icon("res://icons/HealthNode.svg")
extends Node
class_name HealthNode

@export var hit_points : int
@export var max_hit_points_base : int
var max_hit_points : int

@export var stats : StatsNode

signal died()

func _ready():
	max_hit_points += stats.endurance

func take_damage(value):
	hit_points -= clampi(value, 0, 999)
	check_alive()

func heal(value):
	hit_points += clampi(value, 0, max_hit_points)

func check_alive():
	if hit_points <= 0:
		print('dead')
		died.emit()
		pass
	
