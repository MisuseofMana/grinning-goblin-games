extends Node2D 
class_name EnemyController

@export var animations : AnimationPlayer

var allEnemies : Array[Node]

signal show_accept_button()
signal all_enemies_turn_over()
signal all_enemies_died()
signal enemy_card_replaced(card: Resource, newOwner: UnitTarget)

func _ready():
#	remove testing enemies from enemies node
	for testEnemy in get_children():
		testEnemy.queue_free()

# called from battle scene controller
func startEnemyPhase():
	allEnemies = get_children()
	startEnemiesTurn()

func startEnemiesTurn():
	if allEnemies.size():
		animations.clear_queue()
		var randomCard : Resource = allEnemies.front().deckNode.deck.pick_random()
		enemy_card_replaced.emit(randomCard, allEnemies[0])
		animations.play('fly_in')
	else:
		all_enemies_turn_over.emit()

func enemyHasTakenTurn():
	print('calling takenTurn')
	allEnemies.remove_at(0)
	startEnemiesTurn()

func checkForOtherEnemies():
	if get_children().size() == 0:
		all_enemies_died.emit()

# sequencer for enemy card animations
func animationSequencer(anim_name):
	if anim_name == 'fly_in':
		animations.play('hover')
		show_accept_button.emit()
	if anim_name == 'evaporate':
		enemyHasTakenTurn()
