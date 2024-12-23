extends Node2D 
class_name EnemyController

@export var enemy_card : CardImage
@export var animations : AnimationPlayer

var allEnemies : Array[Node]

signal show_accept_button()
signal all_enemies_turn_over()

func hookUpEnemySignals(node: Node):
	# hook up new enemy node signals
	if node is EnemyUnit:
		node.enemy_is_waiting_for_response.connect(enemyWaitingForResponse)
		node.enemy_has_taken_turn.connect(enemyHasTakenTurn)

# called from battle scene controller
func startEnemyPhase():
	allEnemies = get_children()
	startEnemiesTurn()

func startEnemiesTurn():
	if allEnemies.size():
		allEnemies[0].take_turn()
	else:
		all_enemies_turn_over.emit()

func enemyWaitingForResponse():
	show_accept_button.emit()

func enemyHasTakenTurn():
	allEnemies.remove_at(0)
	startEnemiesTurn()
