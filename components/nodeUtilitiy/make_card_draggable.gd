extends Node
class_name MakeCardDraggable

@onready var parent : CardComponent = get_parent()
@onready var parentScale : Vector2 = get_parent().scale

@export var detection_area : TwoWayDetection

const pointing_hand = preload("res://art/grab.png")
const custom_arrow = preload("res://art/ui/cursor.png")

var target
var isValidTarget : bool

var is_dragging : bool = false
@export var undraggable: bool = false
var card_origin : Vector2
var card_rotation
const SPEED := 0.2
const delay := 4

signal card_was_picked_up()
signal card_was_dropped()
signal card_was_used_on(target: Node)
signal reduce_action_points

func _ready():
	parent.gui_input.connect(_mouse_input_on_parent)
	parent.mouse_entered.connect(_on_mouse_entered)
	parent.mouse_exited.connect(_on_mouse_exited)

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(parent, "global_position", parent.get_global_mouse_position() + Vector2(-parent.size.x / 4, -parent.size.y / 4), delay * delta)
		
func _mouse_input_on_parent(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not undraggable:
			card_origin = parent.position
			create_tween().tween_property(parent, "scale", parentScale * 0.5, SPEED)
			is_dragging = true
			card_was_picked_up.emit()
		elif event.is_released() and detection_area.drop_spot_is_valid():
			reduce_action_points.emit()
			card_was_used_on.emit(detection_area.overlapping_areas[0].owner)
			is_dragging = false
			if parent.card_stats.is_burn_card:
				parent.burnCard()
			else:
				parent.discardCard()
		elif not undraggable:
			returnCardToOrigin()

func returnCardToOrigin():
	card_was_dropped.emit()
	is_dragging = false
	undraggable = true
	parent.z_index = 0
	create_tween().tween_property(parent, "position", card_origin, SPEED)
	create_tween().tween_property(parent, "modulate", Color(1,1,1), SPEED)
	create_tween().tween_property(parent, "scale", parentScale, SPEED)
	await get_tree().create_timer(SPEED).timeout
	undraggable = false
	

func _on_mouse_entered():
	if not is_dragging and not undraggable:
		Input.set_custom_mouse_cursor(pointing_hand, Input.CURSOR_POINTING_HAND, Vector2(12, 16))
		parent.z_index = 100
		create_tween().tween_property(parent, "scale", parentScale * 1.1, SPEED)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(custom_arrow)
	if not is_dragging and not undraggable:
		parent.z_index = 0
		create_tween().tween_property(parent, "scale", parentScale, SPEED)

func make_undraggable():
	parent.mouse_default_cursor_shape = Control.CURSOR_ARROW
	undraggable = true
	
func make_draggable():
	parent.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	undraggable = false
