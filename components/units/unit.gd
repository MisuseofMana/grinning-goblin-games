@tool
extends Node2D
class_name Unit

@export var unit_stats : UnitStats
@onready var unit_sprite: AnimatedSprite2D = $UnitSprite
@onready var health_bar: ProgressBar = $ReadoutContainer/ProgressBar
@onready var health_num: Label = $ReadoutContainer/Label
@onready var anims: AnimationPlayer = $AnimationPlayer

@onready var card_scene = preload("res://components/cards/draggable_card.tscn")

signal tokens_updated(unit_stats: UnitStats)

func _ready():
	health_bar.max_value = unit_stats.stats.max_health
	updateHealthDisplay()
	for animation_name in unit_stats.animation_names:
		if not unit_sprite.sprite_frames.has_animation(animation_name):
			unit_sprite.sprite_frames.add_animation(animation_name)
			setAnimationFrames('res://art/cards/sprites/' + unit_stats.character_type + '/' + animation_name + '/', animation_name)
	unit_sprite.animation = 'idle'
	unit_sprite.autoplay = 'idle'

func die():
	if unit_stats.is_self:
		print('game over')
	else:
		anims.play('death_animation')
#		check for other living units
		
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
	if(unit_stats.stats.health > 0):
		anims.play("take_damage")
		unit_stats.stats.health -= 1
		updateHealthDisplay()
		if unit_stats.stats.health <= 0:
			die()

func addToHealth():
	if(unit_stats.stats.health < unit_stats.stats.max_health):
		anims.play("heal")
		unit_stats.stats.health += 1
		updateHealthDisplay()

func updateHealthDisplay():
	health_num.text = str(unit_stats.stats.health, "/", unit_stats.stats.max_health)
	health_bar.value = unit_stats.stats.health

func updateTokens():
	tokens_updated.emit(unit_stats.tokens)
	
func take_turn():
	print('take_turn no overwritten')
	pass
