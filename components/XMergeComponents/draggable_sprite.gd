extends Area2D

@export var attrs : UnitData
@onready var area_2d = $"."
@onready var draggable_sprite = $DraggableSprite
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var grab_sound = $GrabSound
@onready var drop_sound = $DropSound
@onready var merge_sound = $MergeSound

var is_dragging = false
var delay = 0.1
var drop_spots
var dragging_from_spot
var level_dots

func _ready():
	var inital_texture = attrs.unit_type + str(attrs.unit_level)
	draggable_sprite.texture = UnitSprites.PACKED[inital_texture]
	drop_spots  = get_tree().get_nodes_in_group("drop_spot_group")
	
func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position(), delay * delta)

func _on_mouse_entered():
	Globals.displayUnit = {
		'type': attrs.unit_type,
		'level': attrs.unit_level,
		'max': attrs.unit_max_level
	}

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if draggable_sprite.get_rect().has_point(to_local(event.position)):
				dragging_from_spot = area_2d.global_position
				is_dragging = true
				grab_sound.play()
		else:
			is_dragging = false
			drop_sound.play()
			for drop_spot in drop_spots:
				if drop_spot.has_overlapping_areas() and drop_spot.get_overlapping_areas().has(area_2d):
#					if there a unit already exists here then try to merge them
					var slot_contents = drop_spot.get_overlapping_areas()
					if slot_contents.size() == 2:
						var first = slot_contents[0].attrs
						var second = slot_contents[1].attrs
						if first.unit_level == second.unit_level and first.unit_type == second.unit_type:
							await tweenToSlot(drop_spot, true)
							first.unit_level = second.unit_level + 1
							var textureString = first.unit_type + str(first.unit_level)
							draggable_sprite.texture = UnitSprites.PACKED[textureString]
							slot_contents[1].queue_free()
						elif first.unit_level != second.unit_level:
							returnToOldSlot(dragging_from_spot)
					else:
						await tweenToSlot(drop_spot, false)

func returnToOldSlot(from_pos):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", from_pos, delay)
	await tween.finished
						
func tweenToSlot(drop_spot, isMerging):
	var snap_postion = drop_spot.position
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", snap_postion, delay)
	await tween.finished
	
	if isMerging:
		merge_sound.play()
		emitParticles()

func emitParticles():
	particles.emitting = true
	var timer := Timer.new()
	timer.wait_time = 1.0 # 1 second
	timer.one_shot = true # don't loop, run once
	timer.autostart = true # start timer when added to a scene
	timer.connect("timeout", _on_timer_timeout)
	add_child(timer)
	
func _on_timer_timeout() -> void:
	particles.emitting = false
