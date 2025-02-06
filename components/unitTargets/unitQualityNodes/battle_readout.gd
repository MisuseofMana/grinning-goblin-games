class_name TargetReadout extends Control

@export var statsNode : StatsNode
@export var healthNode : HealthNode
@export var unit: UnitTarget

@onready var health_bar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/ProgressBar/Label

@onready var token_container = $VBoxContainer/TokenContainer

func _ready():
	update_readout(healthNode.hit_points, healthNode.max_hit_points)

func update_readout(currentHealth, maxHealth):
	label.text = str(currentHealth) + "/" + str(maxHealth)
	health_bar.value = currentHealth
	health_bar.max_value = maxHealth
	
func add_token(token: PackedScene, tokenVal: int):
	var newToken = token.instantiate()
	token_container.add_child(newToken)
	newToken.tokenValue = tokenVal

func cycle_down_tokens():
	var tokens : Array[Node] = token_container.get_children()
	if tokens.is_empty():
		return
	else:
		for token : Token in tokens:
			token.reduce_token_value()
	
