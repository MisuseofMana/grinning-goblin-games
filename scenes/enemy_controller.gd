extends Node2D 
class_name EnemyController

@export var animations : AnimationPlayer

var allEnemies : Array[Node]

signal show_accept_button()
signal all_enemies_turn_over()
signal set_card_owner(owner : Unit)
signal set_card_stats(stats : CardStats)
signal all_enemies_died()

func set_up_enemies(enemyArray : Array[UnitStats]):
	for unitstat in enemyArray:
		print('set_up_enemies')
		#var newEnemyUnit = UNIT.instantiate()
		#newEnemyUnit.check_for_other_enemies.connect(checkForOtherEnemies)
		#newEnemyUnit.unit_stats = unitstat
		#add_child(newEnemyUnit)

# called from battle scene controller
func startEnemyPhase():
	allEnemies = get_children()
	startEnemiesTurn()

func startEnemiesTurn():
	if allEnemies.size():
		var randomCard : CardStats = allEnemies[0].unit_stats.deck.pick_random()
		set_card_owner.emit(allEnemies[0])
		set_card_stats.emit(randomCard)
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
