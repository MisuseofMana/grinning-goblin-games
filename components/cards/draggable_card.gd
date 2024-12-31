extends Control

@onready var card : CardComponent = $Card
@onready var collider = $TwoWayDetection/CollisionShape2D

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

var target
var isValidTarget : bool

var is_dragging : bool = false
var undraggable: bool = false
var card_origin : Vector2
var card_rotation
const SPEED := 0.2
const delay := 4

signal card_discarded(cardStats : CardStats)
signal card_burnt(cardStats : CardStats)
signal action_points_reduced_by(howMany : int)

func _ready():
	collider.disabled = true
	
func set_card_stats(cardStats: CardStats):
	card.card_stats = cardStats
	card.updateCardData()

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(self, "global_position", get_global_mouse_position() + Vector2(0, card.size.y / 4), delay * delta)

func check_drop_spot_validity(area):
	target = area.owner
	if card.card_stats.targets_self == area.owner.stats.is_friendly:
		create_tween().tween_property(self, "modulate", Color(0, 0.941, 0.376), SPEED)
		isValidTarget = true
	else:
		create_tween().tween_property(self, "modulate", Color(1, 0.435, 0.366), SPEED)
		isValidTarget = false

func event_on_card(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			collider.disabled  = false
			card_origin = position
			create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
			is_dragging = true
		else:
			if isValidTarget:
				card.card_stats.card_effect(target)
				is_dragging = false
				action_points_reduced_by.emit(card.card_stats.play_cost)
				if card.card_stats.one_use:
					card_burnt.emit(card.card_stats)
				else:
					card_discarded.emit(card.card_stats)
				get_parent().queue_free()
			else:
				returnCardToOrigin()

func returnCardToOrigin():
	collider.disabled = true
	z_index = 0
	create_tween().tween_property(self, "modulate", Color(1,1,1), SPEED)
	create_tween().tween_property(self, "position", card_origin, SPEED)
	is_dragging = false

func _on_mouse_entered():
	if not is_dragging:
		z_index = 100
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging:
		z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
