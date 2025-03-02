extends Control

@onready var current_ap_label = $Sprite2D/HBoxContainer/CurrentAP
@onready var max_ap_label = $Sprite2D/HBoxContainer/MaxAP
@onready var particles = $GPUParticles2D

signal ran_out_of_ap

var remaining_ap : int :
	set(newValue):
		Utilities.animateLabelFromTo(newValue, remaining_ap, current_ap_label)
		remaining_ap = newValue
		if remaining_ap <= 0:
			ran_out_of_ap.emit()
			
var max_ap : int :
	set(newValue):
		Utilities.animateLabelFromTo(newValue, remaining_ap, max_ap_label)
		max_ap = newValue

func _ready():
	remaining_ap = GameState.saved_action_points
	max_ap = GameState.saved_max_action_points

func reduce_max_ap_by(howMuch: int):
	max_ap -= howMuch
	
func increase_max_ap_by(howMuch: int):
	max_ap += howMuch

func reduce_ap_by(howMuch: int):
	remaining_ap -= howMuch
	
func increase_ap_by(howMuch: int):
	remaining_ap += howMuch
