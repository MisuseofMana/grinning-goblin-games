extends Area2D

@export var attrs : UnitData
@onready var area_2d = $"."
@onready var draggable_sprite = $DraggableSprite

var is_dragging = false
var mouse_offset
var delay = 0.2
var drop_spots
var dragging_from_spot

func _ready():
	draggable_sprite.texture = attrs.unit_texture
	drop_spots  = get_tree().get_nodes_in_group("drop_spot_group")
	
func _physics_process(delta):
	if is_dragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position(), delay * delta)
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if draggable_sprite.get_rect().has_point(to_local(event.position)):
				dragging_from_spot = area_2d.global_position
				is_dragging = true
		else:
			is_dragging = false
			for drop_spot in drop_spots:
				if drop_spot.has_overlapping_areas() and drop_spot.get_overlapping_areas().has(area_2d):
#					if there a unit already exists here then try to merge them
					print(drop_spot.get_overlapping_areas().size())
					var slot_contents = drop_spot.get_overlapping_areas()
					if slot_contents.size() == 2:
						var first = slot_contents[0].attrs
						var second = slot_contents[1].attrs
						if first.unit_level == second.unit_level and first.unit_type == second.unit_type:
							tweenToSlot(drop_spot)
						drop_spot.get_overlapping_areas()[0].attrs.unit_level
						
func tweenToSlot(drop_spot):
	var snap_postion = drop_spot.position
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", snap_postion, delay)
