extends Node2D
class_name BattleScene

@onready var battle_scene = $"."

@onready var enemies = $Enemies
@onready var turn_label = $FlavorAssets/TurnIndicator/TurnLabel
@onready var turn_sign = $FlavorAssets/TurnIndicator/TurnSign
@onready var turn_indicator = $FlavorAssets/TurnIndicator

@onready var turn_change_sound = $Sounds/TurnChangeSound
@onready var anims = $FlavorAssets/AnimationPlayer
@onready var enemy_markers = $EnemyMarkers
@onready var end_turn_button = $EndTurnButton

@export var stage_background = Texture2D
@export var player : BattleUnit
@export var card_battle_hud : CardBattleHud
@export var enemy_logic : EnemyController

enum Locations {
	FOREST,
	PLAINS,
	HILLS,
	CAVE
}

var currentLocation = Locations.FOREST

var monsters : Dictionary = {
	Locations.FOREST: [
		preload("res://components/battleUnits/variants/enemies/forestEnemies/goblin.tscn"),
		preload("res://components/battleUnits/variants/enemies/forestEnemies/rat/rat.tscn")
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
	
func runWinEncounter():
	runPhase(TurnPhases.GO_TO_NEXT_ENCOUNTER)

func runPhase(phase: TurnPhases):
	match phase:
		TurnPhases.START_NEW_ENCOUNTER:
			var howManyMonsters = randi_range(1, 3)
			for number in howManyMonsters: 
				var newMonster : PackedScene = monsters[currentLocation].pick_random()
				var monsterNode : BattleUnit = newMonster.instantiate()
				monsterNode.position = enemy_markers.get_child(number).position
				monsterNode.name = 'Enemy_' + str(number)
				enemies.add_child(monsterNode)
				monsterNode.unit_died.connect(checkForLivingEnemies)
#			handle card setup from player
			runPlayerTurn()
		TurnPhases.PLAYER_UPKEEP:
			card_battle_hud.discardHand()
#			reduce token values
		TurnPhases.START_PLAYERS_TURN:
			end_turn_button.disabled = false
			showTurnSwap("Your Turn")
			SaveData.players_turn = true
			card_battle_hud.actionPointsNode.refresh_action_points()
			card_battle_hud.deckPileNode.draw_hand_size()
			card_battle_hud.changeAllCardAvailability()
		TurnPhases.ENEMIES_TURN:
			end_turn_button.disabled = true
			showTurnSwap("Enemy Turn")
			SaveData.players_turn = false
			card_battle_hud.changeAllCardAvailability()
			enemy_logic.startEnemyPhase()
		TurnPhases.GO_TO_NEXT_ENCOUNTER:
			card_battle_hud.fullDeckReset()
			#anims.play("scroll_bg")

func showTurnSwap(text):
	turn_change_sound.play()
	await create_tween().tween_property(turn_indicator, "global_position", Vector2(0, -64), 0.3).finished
	turn_label.text = text
	turn_label.show()
	create_tween().tween_property(turn_indicator, "global_position", Vector2(0, 0), 0.3)
	
func animationHandler(anim_name):
	if anim_name == "scroll_bg":
		runPhase(TurnPhases.START_NEW_ENCOUNTER)
		
func checkForLivingEnemies():
	print('check for living enemies')
	if enemies.get_children().is_empty():
		runWinEncounter()
