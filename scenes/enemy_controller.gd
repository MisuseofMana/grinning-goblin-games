extends Node2D 
class_name EnemyController

@export var animations : AnimationPlayer

var allEnemies : Array[Node]

signal show_accept_button()
signal all_enemies_turn_over()
signal set_card_stats(stats : CardStats)
signal all_enemies_died()
signal set_card_owner(cardOwner: UnitSprite)

func _ready():
#	remove testing enemies from enemies node
	for testEnemy in get_children():
		testEnemy.queue_free()

func set_up_enemies(enemyArray : Array[UnitStats]):
	for unitstat in enemyArray:
		print(unitstat)

# called from battle scene controller
func startEnemyPhase():
	allEnemies = get_children()
	startEnemiesTurn()

func startEnemiesTurn():
	if allEnemies.size():
		var randomCard = allEnemies[0].deck.deck.pick_random()
		set_card_stats.emit(randomCard)
		set_card_owner.emit(allEnemies[0])
		animations.play('fly_in')
	else:
		all_enemies_turn_over.emit()

func enemyHasTakenTurn():
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
