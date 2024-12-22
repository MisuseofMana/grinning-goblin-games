extends Node2D
class_name BattleScene

@onready var battle_scene = $"."
@onready var card_interface = $HandOfCards
@onready var background: Sprite2D = $Background
@onready var player: Unit = $Player
@onready var enemies = $Enemies
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSound
@onready var enemy_card_template = $EnemyCardContainer/Path2D/PathFollow2D/EnemyCardTemplate

@export var stage_background = Texture2D
@export var player_deck : Array[CardStats] = []

@export var hand_of_cards : HandOfCards

var players_turn : bool = true

signal players_turn_activated()

func _ready():
	await showTurnSwap("Your Turn", true)

func _on_card_interface_ran_out_of_action_points():
	run_enemy_turn()

func showTurnSwap(text, isPlayersTurn):
	players_turn = isPlayersTurn
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(1).timeout
	turn_label.hide()
	
func run_enemy_turn():
	showTurnSwap("Enemy Turn", false)
	hand_of_cards.changeAllCardAvailability()
#	run enemy logic
	for enemy : Unit in enemies.get_children():
		enemy_card_template.active_enemy = enemy
		await enemy.take_turn()

func return_to_players_turn():
	showTurnSwap("Your Turn", true)
	players_turn_activated.emit()
	hand_of_cards.changeAllCardAvailability()
