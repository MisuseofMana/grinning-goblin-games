@tool
class_name Unit extends AnimatedSprite2D

@export var unit_data : UnitStats
@onready var unit_animations = $"."
@onready var health_num = $Label
@onready var health_bar = $ProgressBar
@onready var anims = $AnimationPlayer
@onready var counters = $Counters

func _ready():
	unit_data.unit = self	
	health_bar.max_value = unit_data.max_health
	updateHealthDisplay()
	unit_data.health_reduced.connect(subtractFromHealth)
	unit_data.counters_changed.connect(updateCounterDisplay)
	
#	add new animation name
	for animation_name in unit_data.animation_names:
		if not unit_animations.sprite_frames.has_animation(animation_name):
			unit_animations.sprite_frames.add_animation(animation_name)
			setAnimationFrames('res://art/cards/sprites/' + unit_data.character_type + '/' + animation_name + '/', animation_name)
	unit_animations.animation = 'idle'

func setAnimationFrames(path, animation_name):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not file_name.contains('import'):
				unit_animations.sprite_frames.add_frame(animation_name, load(path + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
		
func subtractFromHealth():
	anims.play("take_damage")
	unit_data.health -= 1
	updateHealthDisplay()

func updateHealthDisplay():
	health_num.text = str(unit_data.health, "/", unit_data.max_health)
	health_bar.value = unit_data.health
	
func updateCounterDisplay(counterType):
	counters.addCounter(counterType)
