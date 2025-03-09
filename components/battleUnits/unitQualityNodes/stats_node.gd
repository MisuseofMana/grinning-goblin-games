@icon("res://icons/StatsNode.svg")
extends Node
class_name StatsNode

@export_category("Stats")
@export var muscle : int = 0
@export var finesse : int = 0
@export var endurance : int = 0
@export var knowledge : int = 0
@export var nuance : int = 0

@export_category("Debuffs")
@export var debuffs : Dictionary = {}
