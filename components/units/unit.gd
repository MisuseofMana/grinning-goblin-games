@tool
class_name Unit extends Node2D

@export var unit_data : UnitStats
@onready var unit_sprite: AnimatedSprite2D = $UnitSprite
@onready var health_bar: ProgressBar = $ProgressBar
@onready var health_num: Label = $Label
@onready var anims: AnimationPlayer = $AnimationPlayer
@onready var counters: GridContainer = $Counters

func _ready():
	unit_data.unit = self	
	health_bar.max_value = unit_data.max_health
	updateHealthDisplay()
	unit_data.counters_changed.connect(updateCounterDisplay)
	
#	add new animation name
	for animation_name in unit_data.animation_names:
		if not unit_sprite.sprite_frames.has_animation(animation_name):
			unit_sprite.sprite_frames.add_animation(animation_name)
			setAnimationFrames('res://art/cards/sprites/' + unit_data.character_type + '/' + animation_name + '/', animation_name)
	unit_sprite.animation = 'idle'

func die():
	if unit_data.character_type == 'self':
		print('game over')
	elif unit_data.character_type == 'enemy':
#		destroy self
		pass
		

func setAnimationFrames(path, animation_name):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not file_name.contains('import'):
				unit_sprite.sprite_frames.add_frame(animation_name, load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func subtractFromHealth():
	anims.play("take_damage")
	unit_data.health -= 1
	updateHealthDisplay()
	if unit_data.health <= 0:
		die()

func updateHealthDisplay():
	health_num.text = str(unit_data.health, "/", unit_data.max_health)
	health_bar.value = unit_data.health
	
func updateCounterDisplay(counterType):
	counters.addCounter(counterType)
