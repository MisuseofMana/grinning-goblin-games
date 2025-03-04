class_name Token extends TextureRect

@onready var label = $Label

var tokenValue : int = 0:
	set(newValue):
		var oldValue = tokenValue
		animateLabelFromTo(newValue, oldValue)
		tokenValue = newValue

func _ready():
	hide()

func run_token_effect():
	var unit: UnitTarget = owner.unit
	unit.takeDamage(tokenValue)

func reduce_token_value():
	run_token_effect()
	tokenValue -= 1

func animateLabelFromTo(to: int, from: int):
	if to >= 1:
		show()
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		if incrementer <= 0:
			hide()
			break
		label.text = str(incrementer)
