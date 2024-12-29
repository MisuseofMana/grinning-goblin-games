extends Control

@onready var overlap_detection = $Card/OverlapDetection
@onready var card : CardComponent = $Card

const CARD_TEMPLATE_BACK = preload("res://art/cards/card-template-back.png")

var target : Area2D
var isValidTarget : bool

var is_dragging : bool = false
var undraggable: bool = false
var card_origin : Vector2
var card_rotation
const SPEED := 0.2
const delay := 4
	
func set_card_stats(cardStats: CardStats):
	card.card_stats = cardStats
	card.updateCardData()

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(self, "global_position", get_global_mouse_position() + Vector2(0, card.size.y / 4), delay * delta)

func event_on_card(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			card_origin = position
			create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
			is_dragging = true
		else:
			if isValidTarget:
				card.runCardEffect(target)
			else:
				returnCardToOrigin()

func returnCardToOrigin():
	create_tween().tween_property(self, "position", card_origin, SPEED)
	is_dragging = false
	
func overlaps_changed(overlaps : Array[Area2D]):
	target = overlaps[0]
	print(target.owner)
	if target.owner is UnitSprite:
		print('unit overlap')
	elif target.owner is CardComponent:
		print('card overlap')

func _on_mouse_entered():
	if not is_dragging:
		z_index = 100
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging:
		z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
