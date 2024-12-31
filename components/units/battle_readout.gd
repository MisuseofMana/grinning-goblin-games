extends VBoxContainer

@export var stats : StatsNode
@export var health : HealthNode

@onready var health_bar = $ProgressBar
@onready var label = $Label

func _ready():
	update_readout(health.hit_points, health.max_hit_points)

func update_readout(currentHealth, maxHealth):
	label.text = str(currentHealth) + "/" + str(maxHealth)
	health_bar.value = currentHealth
	health_bar.max_value = maxHealth
	
