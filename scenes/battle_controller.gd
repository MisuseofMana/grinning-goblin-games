extends Node2D
class_name BattleScene

@onready var battle_scene = $"."
@onready var card_interface = $HandOfCards
@onready var background = $FlavorAssets/Background

@onready var player: Unit = $Player
@onready var enemies = $Enemies
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSound
@onready var enemy_card_template = $EnemyCardContainer/Path2D/PathFollow2D/EnemyCardTemplate

@export var stage_background = Texture2D

@export var hand_of_cards : HandOfCards
@export var enemy_logic : EnemyController

var players_turn : bool = true

enum TurnPhases {
	START_PLAYERS_TURN,
	ENEMIES_TURN,
}

func _ready():
	await showTurnSwap("Your Turn")

func runEnemiesTurn():
	runPhase(TurnPhases.ENEMIES_TURN)

func runPlayerTurn():
	runPhase(TurnPhases.START_PLAYERS_TURN)

func runPhase(phase: TurnPhases):
	match phase:
		TurnPhases.START_PLAYERS_TURN:
			await showTurnSwap("Your Turn")
			players_turn = true
			hand_of_cards.refreshActionPoints()
			await hand_of_cards.discardHand()
			hand_of_cards.drawHandSize()
			hand_of_cards.changeAllCardAvailability()
		TurnPhases.ENEMIES_TURN:
			await showTurnSwap("Enemy Turn")
			players_turn = false
			hand_of_cards.changeAllCardAvailability()
			enemy_logic.startEnemyPhase()

func showTurnSwap(text):
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(0.7).timeout
	turn_label.hide()
