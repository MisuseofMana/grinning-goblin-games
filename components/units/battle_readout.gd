extends VBoxContainer

@export var stats : StatsNode
@export var health : HealthNode

@onready var label = $Label

func _ready():
	label.text = str(health.hit_points) + "/" + str(health.max_hit_points)
	
