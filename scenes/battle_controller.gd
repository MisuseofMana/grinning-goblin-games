extends Node2D
class_name BattleScene

@onready var battle_scene = $"."
@onready var card_interface = $HandOfCards

@onready var enemies = $Enemies
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSound
@onready var anims = $FlavorAssets/AnimationPlayer
@onready var enemy_markers = $EnemyMarkers

@export var stage_background = Texture2D
@export var player : UnitTarget
@export var hand_of_cards : HandOfCards
@export var deckPile : DeckPile
@export var enemy_logic : EnemyController

var players_turn : bool = true : 
	set(value):
		players_turn = value
		if players_turn:
			get_tree().call_group("enemy_hitboxes", "enableTargeting")
		else:
			get_tree().call_group("enemy_hitboxes", "disableTargeting")

enum Locations {
	FOREST,
	PLAINS,
	HILLS,
	CAVE
}

var currentLocation = Locations.FOREST

var monsters : Dictionary = {
	Locations.FOREST: [
		preload("res://components/unitTargets/variants/enemies/forestEnemies/goblin.tscn"),
	]
}

enum TurnPhases {
	START_NEW_ENCOUNTER,
	PLAYER_UPKEEP,
	START_PLAYERS_TURN,
	ENEMIES_TURN,
	GO_TO_NEXT_ENCOUNTER
}

func _ready():
	runPhase(TurnPhases.START_NEW_ENCOUNTER)

func runPlayerUpkeep():
	runPhase(TurnPhases.PLAYER_UPKEEP)

func runPlayerTurn():
	runPhase(TurnPhases.START_PLAYERS_TURN)

func runEnemiesTurn():
	runPhase(TurnPhases.ENEMIES_TURN)
	
func runEndEncounter():
	runPhase(TurnPhases.GO_TO_NEXT_ENCOUNTER)

func runPhase(phase: TurnPhases):
	match phase:
		TurnPhases.START_NEW_ENCOUNTER:
			var howManyMonsters = randi_range(1, 3)
			for number in howManyMonsters: 
				var newMonster : PackedScene = monsters[currentLocation].pick_random()
				var monsterNode = newMonster.instantiate()
				monsterNode.position = enemy_markers.get_child(number).position
				monsterNode.name = 'Enemy_' + str(number)
				enemies.add_child(monsterNode)
			runPlayerTurn()
		TurnPhases.PLAYER_UPKEEP:
			hand_of_cards.discardHand()
#			reduce token values
		TurnPhases.START_PLAYERS_TURN:
			showTurnSwap("Your Turn")
			players_turn = true
			hand_of_cards.refreshActionPoints()
			deckPile.get_cards_from_deck(player.deckNode.hand_size)
			hand_of_cards.changeAllCardAvailability()
		TurnPhases.ENEMIES_TURN:
			showTurnSwap("Enemy Turn")
			players_turn = false
			hand_of_cards.changeAllCardAvailability()
			enemy_logic.startEnemyPhase()
		TurnPhases.GO_TO_NEXT_ENCOUNTER:
			player.deck.put_discard_into_deck()
			anims.play("scroll_bg")

func showTurnSwap(text):
	turn_label.text = text
	turn_change_sound.play()
	turn_label.show()
	await get_tree().create_timer(0.7).timeout
	turn_label.hide()
	
func animationHandler(anim_name):
	if anim_name == "scroll_bg":
		runPhase(TurnPhases.START_NEW_ENCOUNTER)
