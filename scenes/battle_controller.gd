extends Node2D
class_name BattleScene

@onready var battle_scene = $"."

@onready var card_interface: HandOfCards = $CardInterface
@onready var background: Sprite2D = $Background
@onready var player: Unit = $Player
@onready var action_points_counter = $Sprite2D/ActionPointsCounter
@onready var particles = $Sprite2D/GPUParticles2D
@onready var turn_label = $TurnLabel
@onready var turn_change_sound = $Sounds/TurnChangeSouind

@export var stage_background = Texture2D
@export var player_deck : Array[CardStats] = []

var remaining_action_points : int = 3 :
	set(value):
		remaining_action_points = value
		action_points_counter.text = str(remaining_action_points)
		if remaining_action_points <= 0:
			run_enemy_turn()

var players_turn : bool = true

func _ready():
	card_interface.card_base.card_used.connect(reduceActionPoints)

func reduceActionPoints(value: CardStats):
	remaining_action_points -= value.play_cost
	particles.emitting = true

func run_enemy_turn():
	players_turn = false
	turn_label.text = "Enemies Turn"
	turn_change_sound.play()
	turn_label.show()
	await battle_scene.get_tree().create_timer(1.8).timeout
	turn_label.hide()
	card_interface.discardHand()
#	discard hand
#	run enemy logic
#	give back players turn

	return
