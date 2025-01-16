@icon("res://icons/HealthNode.svg")
extends Node
class_name HealthNode

@export var hit_points : int
@export var max_hit_points_base : int
var max_hit_points : int

@export var statsNode : StatsNode
@export var modifiers : Modifiers

signal died()
signal health_updated(newHealth, newMaxHealth)

func _ready():
	max_hit_points += max_hit_points_base + modifiers.getPrimaryStatMod(statsNode.endurance)
	hit_points = clampi(hit_points, 1, max_hit_points)

func take_damage(value):
	var howMuch = value
	while howMuch > 0:
		await get_tree().create_timer(0.1).timeout
		howMuch -= 1
		hit_points -= clampi(1, 0, max_hit_points)
		health_updated.emit(hit_points, max_hit_points)
	check_alive()

func heal(value):
	var howMuch = value
	while howMuch > 0:
		await get_tree().create_timer(0.1).timeout
		howMuch -= 1
		hit_points += clampi(1, 0, max_hit_points)
		health_updated.emit(hit_points, max_hit_points)

func check_alive():
	if hit_points <= 0:
		print('dead')
		died.emit()
	
