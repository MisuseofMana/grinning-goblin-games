extends Node

@export_group('Card Battle Data')
@export var players_turn : bool = true:
	set(value):
		players_turn = value
		if players_turn:
			get_tree().call_group("enemy_hitboxes", "enableTargeting")
		else:
			get_tree().call_group("enemy_hitboxes", "disableTargeting")

@export var player_deck : Array[CardStats] = []
@export var collected_cards : Array[CardStats] = []
@export var deck_pile: Array[CardStats] = []
@export var discard_pile: Array[CardStats] = []
@export var burn_pile: Array[CardStats] = []

@export var action_points : int = 3
@export var max_action_points : int = 3
@export var hand_size: int = 5

@export_group('Battle Scene Units')
@export var playerUnit : UnitTarget
@export var friendlyUnits : Array[UnitTarget]
@export var enemyUnits : Array[UnitTarget]

@export_group('Player Stats')
