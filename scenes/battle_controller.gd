extends Node2D
class_name BattleScene

@onready var battle_scene = $"."
@onready var card_interface = $HandOfCards

@onready var player: Unit = $Player
@onready var enemies = $Enemies
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSound
@onready var enemy_card_template = $EnemyCardContainer/Path2D/PathFollow2D/EnemyCardTemplate
@onready var anims = $FlavorAssets/AnimationPlayer

@export var stage_background = Texture2D

@export var hand_of_cards : HandOfCards
@export var enemy_logic : EnemyController

var players_turn : bool = true

enum Locations {
	FOREST,
	PLAINS,
	HILLS,
	CAVE
}

var currentLocation = Locations.FOREST

var monsters : Dictionary = {
	Locations.FOREST: [
		preload("res://components/units/UnitDictionary/UnitTypes/goblin.tres")
	]
}

var selectedEnemies : Array[UnitStats] = []

enum TurnPhases {
	START_NEW_ENCOUNTER,
	START_PLAYERS_TURN,
	ENEMIES_TURN,
	GO_TO_NEXT_ENCOUNTER
}

func _ready():
	await showTurnSwap("Your Turn")

func buildNewEncounter():
	selectedEnemies = []
	var howManyMonsters = randi_range(1, 2)
	for number in howManyMonsters: 
		selectedEnemies.append(monsters[currentLocation].pick_random())

func runEnemiesTurn():
	runPhase(TurnPhases.ENEMIES_TURN)

func runPlayerTurn():
	runPhase(TurnPhases.START_PLAYERS_TURN)

func runPhase(phase: TurnPhases):
	match phase:
		TurnPhases.START_NEW_ENCOUNTER:
			buildNewEncounter()
			enemies.set_up_enemies(selectedEnemies)
#			create new enemies
#			shuffle all cards into deck
#			start player phase
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
		TurnPhases.GO_TO_NEXT_ENCOUNTER:
			anims.play("scroll_bg")

func showTurnSwap(text):
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(0.7).timeout
	turn_label.hide()
	
func animationHandler(anim_name):
	if anim_name == "scroll_bg":
		runPhase(TurnPhases.START_NEW_ENCOUNTER)
