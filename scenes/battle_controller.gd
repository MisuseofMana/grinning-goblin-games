extends Node2D
class_name BattleScene

@onready var card_interface: HandOfCards = $CardInterface
@onready var background: Sprite2D = $Background
@onready var player: Unit = $Player
@onready var action_points_counter: Label = $ActionPointsCounter

@export var stage_background = Texture2D
@export var player_deck : Array[CardStats] = []

var remaining_action_points : int = 3 : 
	set(value):
		remaining_action_points = value
		action_points_counter.text = str(remaining_action_points)

var players_turn : bool = true

func _ready():
	card_interface.card_base.card_used.connect(reduceActionPoints)

func reduceActionPoints(value: CardStats):
	remaining_action_points -= value.play_cost
