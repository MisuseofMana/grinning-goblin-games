extends Node

@export var playersTurn : bool = true

@export var playerDeck : Array[CardStats] = []
@export var discardedCards: Array[CardStats] = []
@export var bunredCards: Array[CardStats] = []

@export var saved_action_points : int = 3
@export var saved_max_action_points : int = 3
@export var saved_hand_size: int = 5

@export var playerUnit : UnitTarget
@export var friendlyUnits : Array[UnitTarget]
@export var enemyUnits : Array[UnitTarget]
