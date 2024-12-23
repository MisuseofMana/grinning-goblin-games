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
@export var player_deck : Array[CardStats] = []

@export var hand_of_cards : HandOfCards
@export var enemy_logic : EnemyController

var players_turn : bool = true

enum TurnPhases {
	START_PLAYERS_TURN,
	PLAYER_USED_CARD,
	ENEMIES_TURN,
	ENEMY_USED_CARD,
	DISCARD_HAND
}

func _ready():
	await showTurnSwap("Your Turn", true)

func runEnemiesTurn():
	runPhase(TurnPhases.ENEMIES_TURN)

func runPhase(phase: TurnPhases):
	match phase:
		TurnPhases.START_PLAYERS_TURN:
			await showTurnSwap("Your Turn", true)
			hand_of_cards.refreshActionPoints()
			hand_of_cards.changeAllCardAvailability()
		TurnPhases.PLAYER_USED_CARD:
			#play used card animation
#			run card effect
#			discard card
#			update action points
			pass
		TurnPhases.ENEMIES_TURN:
			await showTurnSwap("Enemy Turn", false)
			hand_of_cards.changeAllCardAvailability()
			enemy_logic.startEnemyPhase()
		TurnPhases.DISCARD_HAND:
			hand_of_cards.discardHand()

func showTurnSwap(text, isPlayersTurn):
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(0.7).timeout
	turn_label.hide()
