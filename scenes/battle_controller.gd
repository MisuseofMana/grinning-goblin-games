extends Node2D

@onready var card_interface: Node2D = $CardInterface
@onready var background: Sprite2D = $Background
@onready var player: Unit = $Player

@export var stage_background = Texture2D

@export var player_deck : Array[CardStats] = []

var players_turn : bool = true
