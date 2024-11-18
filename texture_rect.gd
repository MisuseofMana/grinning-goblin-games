extends TextureRect

@export var attributes : UnitData
@onready var texturerect = $"."
@onready var merge_particles = $MergeParticles
@onready var level_text = $Panel/level
@onready var race_text = $Panel/race

signal successfulDrop

var draggableType : String = ''
var fallback_texture = TextureRect.new()

func clearSlot():
	print('clearing')
	#attributes.unit_level = 0
	#attributes.unit_texture = null
	#attributes.unit_type = ''
	#texture = null

func _ready():
	merge_particles.emitting = false
	if(attributes.unit_level != 0 && attributes.unit_texture):
		texturerect.texture = attributes.unit_texture
		level_text.text = str(attributes.unit_level)
		race_text.text = attributes.unit_type

func _get_drag_data(at_position):
	var preview_texture = TextureRect.new()
	
	fallback_texture.texture = texture
	preview_texture.texture = texture
	preview_texture.expand_mode = 0.1
	preview_texture.size = Vector2(68,124)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	Globals.activeDragItemType = attributes.unit_type
	Globals.activeDragItemLevel = attributes.unit_level
	Globals.activeDragItemTexture = attributes.unit_texture
	Globals.itemIsBeingDragged = true
	texturerect.connect('successfulDrop', clearSlot)
	
	self_modulate = Color(1,1,1, 0.3)
	
	return preview_texture.texture
	
func _can_drop_data(at_position, data):
#	detect the data is a Texture2D & the drop spot is a matching unit type
	if(Globals.activeDragItemType == attributes.unit_type || attributes.unit_type == ''):
		return (data is Texture2D && attributes.unit_level < attributes.unit_max_level)
	else: 
		self_modulate = Color(1,1,1,1)
		return false

func _drop_data(at_position, data):
	var level : int = 0
	if(attributes.unit_level != 0):
		if(Globals.activeDragItemLevel == attributes.unit_level):
			level = attributes.unit_level + 1
		
		var variableString = Globals.activeDragItemType + str(level)
		texture = UnitSprites.PACKED[variableString]
		level_text.text = str(level)
		race_text.text = attributes.unit_type
		
		merge_particles.emitting = true	#emit particles
		
		#set unit info for new slot
		print('setting new slot data')
		attributes.unit_level = level 
		attributes.unit_texture = texture
		attributes.unit_type = Globals.activeDragItemType
		
	elif (attributes.unit_level == 0):
		attributes.unit_level = Globals.activeDragItemLevel
		attributes.unit_type = Globals.activeDragItemType
		attributes.unit_texture = Globals.activeDragItemTexture
		
		race_text.text = attributes.unit_type
		level_text.text = str(Globals.activeDragItemLevel)
		texture = Globals.activeDragItemTexture
		
	successfulDrop.emit()
	
	emitParticles()
	
func emitParticles():
	var timer := Timer.new()
	timer.wait_time = 1.0 # 1 second
	timer.one_shot = true # don't loop, run once
	timer.autostart = true # start timer when added to a scene
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	
func _on_timer_timeout() -> void:
	# Do stuff here...
	merge_particles.emitting = false
