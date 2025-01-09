extends Node
class_name MakeControlDraggable

@onready var parent : Control = get_parent()
@onready var parentScale : Vector2 = get_parent().scale


var target
var isValidTarget : bool

var is_dragging : bool = false
var undraggable: bool = false
var card_origin : Vector2
var card_rotation
const SPEED := 0.2
const delay := 4

func _ready():
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)
	parent.gui_input.connect(_mouse_input_on_parent)
	
func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(parent, "global_position", parent.get_global_mouse_position() + Vector2(0, parent.size.y / 5), delay * delta)

func _mouse_input_on_parent(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not undraggable:
			print(parentScale)
			create_tween().tween_property(parent, "scale", parentScale * 1.1, SPEED)
			is_dragging = true
		else:
			returnCardToOrigin()

func returnCardToOrigin():
	parent.z_index = 0
	#create_tween().tween_property(self, "modulate", Color(1,1,1), SPEED)
	#create_tween().tween_property(self, "position", card_origin, SPEED)
	#create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
	is_dragging = false
	await get_tree().create_timer(SPEED).timeout
	undraggable = false
	

func _on_mouse_entered():
	if not is_dragging and not undraggable:
		parent.z_index = 100
		create_tween().tween_property(parent, "scale", parentScale * 1.1, SPEED)

func _on_mouse_exited():
	if not is_dragging and not undraggable:
		parent.z_index = 0
		create_tween().tween_property(parent, "scale", parentScale, SPEED)
