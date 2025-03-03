class_name ActionPoints extends Control

signal ran_out_of_ap

@onready var current_ap_label = $Sprite2D/HBoxContainer/CurrentAP
@onready var max_ap_label = $Sprite2D/HBoxContainer/MaxAP
@onready var particles = $GPUParticles2D

@onready var action_points : int = SaveData.action_points:
	set(newValue):
		Utilities.animateLabelFromTo(newValue, action_points, current_ap_label)
		action_points = newValue
		SaveData.action_points = newValue
		if action_points <= 0:
			ran_out_of_ap.emit()

@onready var max_action_points : int = SaveData.max_action_points:
	set(newValue):
		Utilities.animateLabelFromTo(newValue, action_points, max_ap_label)
		max_action_points = newValue
		SaveData.action_points = max_action_points

func reduce_max_ap_by(howMuch: int):
	max_action_points -= howMuch
	
func increase_max_ap_by(howMuch: int):
	max_action_points += howMuch

func reduce_ap_by(howMuch: int):
	action_points -= howMuch
	
func increase_ap_by(howMuch: int):
	action_points += howMuch

func refresh_action_points():
	action_points = max_action_points
