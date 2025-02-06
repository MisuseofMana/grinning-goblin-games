class_name TargetReadout extends Control

@export var statsNode : StatsNode
@export var healthNode : HealthNode
@export var unit: UnitTarget

@onready var health_bar = $VBoxContainer/ProgressBar
@onready var label = $VBoxContainer/ProgressBar/Label

@onready var token_container = $VBoxContainer/TokenContainer

@onready var poison = $VBoxContainer/TokenContainer/Poison
@onready var armor = $VBoxContainer/TokenContainer/Armor
@onready var ward = $VBoxContainer/TokenContainer/Ward

@onready var token_lookup: Dictionary = {
	"poison": poison,
	"armor": armor,
	"ward": ward
}

func _ready():
	update_readout(healthNode.hit_points, healthNode.max_hit_points)

func update_readout(currentHealth, maxHealth):
	label.text = str(currentHealth) + "/" + str(maxHealth)
	health_bar.value = currentHealth
	health_bar.max_value = maxHealth
	
func add_token(tokenKey: String, tokenVal: int):
	var token: Token = token_lookup[tokenKey]
	token.tokenValue += tokenVal

func cycle_down_tokens():
	var tokens : Array[Node] = token_container.get_children()
	if tokens.is_empty():
		return
	else:
		for token : Token in tokens:
			token.reduce_token_value()
	
