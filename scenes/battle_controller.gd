extends Node2D
class_name BattleScene

@onready var battle_scene = $"."

@onready var card_interface: HandOfCards = $CardInterface
@onready var background: Sprite2D = $Background
@onready var player: Unit = $Player
@onready var enemies = $Enemies
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSound

@export var stage_background = Texture2D
@export var player_deck : Array[CardStats] = []

var players_turn : bool = true

func _ready():
	await showTurnSwap("Your Turn", true)

func _on_card_interface_ran_out_of_action_points():
	run_enemy_turn()

func showTurnSwap(text, isPlayersTurn):
	players_turn = isPlayersTurn
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(1.8).timeout
	turn_label.hide()
	
func run_enemy_turn():
	await showTurnSwap("Enemy Turn", false)
	
#	run enemy logic
	#for enemy in enemies.get_children():
		#enemy.take_turn()
	
#	give back players turn
	await showTurnSwap("Your Turn", true)
	drawHand()

func drawHand():
	print('drawing new hand')
	pass
