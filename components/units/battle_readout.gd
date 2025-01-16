extends VBoxContainer

@export var statsNode : StatsNode
@export var healthNode : HealthNode

@onready var health_bar = $ProgressBar
@onready var label = $Label

func _ready():
	update_readout(healthNode.hit_points, healthNode.max_hit_points)

func update_readout(currentHealth, maxHealth):
	label.text = str(currentHealth) + "/" + str(maxHealth)
	health_bar.value = currentHealth
	health_bar.max_value = maxHealth
	
