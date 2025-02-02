@icon("res://icons/StatsNode.svg")
extends Node
class_name StatsNode

@export_group("Stats")
@export var muscle : int = 0
@export var finesse : int = 0
@export var endurance : int = 0
@export var knowledge : int = 0
@export var nuance : int = 0

@export_group("Action Points")
@export var ap_max : int = 3
@export var current_ap : int = 3

@export_group("Debuffs")
@export var debuffs : Dictionary = {}
