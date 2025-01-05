extends Control
class_name DraggableCard

@onready var card : CardComponent = $Card
@onready var collider = $TwoWayDetection/CollisionShape2D
@onready var anims: AnimationPlayer = $AnimationPlayer

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
signal card_used(card : DraggableCard)

func _ready():
	collider.disabled = true
	
func set_card_stats(cardStats: CardStats):
	card.card_stats = cardStats
	card.updateCardData()

func _physics_process(delta):
	if is_dragging:
		create_tween().tween_property(self, "global_position", get_global_mouse_position() + Vector2(0, card.size.y / 5), delay * delta)

func check_drop_spot_validity(areas):
	if areas.size():
		target = areas[0]
		if target.owner is UnitSprite:
			isValidTarget = card.card_stats.targets_self == target.owner.stats.is_friendly
			if isValidTarget:
				create_tween().tween_property(self, "modulate", Color(0, 0.941, 0.376), SPEED)
			else:
				create_tween().tween_property(self, "modulate", Color(1, 0.435, 0.366), SPEED)
		elif target.get_parent() is CardComponent:
			var cardStats = target.get_parent().card_stats
			isValidTarget = cardStats.accepts_card_types.has(card.card_stats.card_type)
			if isValidTarget:
				create_tween().tween_property(self, "modulate", Color(0, 0.941, 0.376), SPEED)
			else:
				create_tween().tween_property(self, "modulate", Color(1, 0.435, 0.366), SPEED)
	if not areas.size():
		create_tween().tween_property(self, "modulate", Color(1,1,1), SPEED)
		isValidTarget = false

func event_on_card(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and not undraggable:
			collider.disabled  = false
			card_origin = position
			create_tween().tween_property(self, "scale", Vector2(0.7, 0.7), SPEED)
			is_dragging = true
		else:
			if isValidTarget:
				if target.owner is UnitSprite:
					card.card_stats.card_effect(target.owner)
				elif target.get_parent() is CardComponent:
					card.card_stats.card_effect(target.get_parent())
				is_dragging = false
				undraggable = true
				card_used.emit(self)
				$SuccessSound.play()
			else:
				undraggable = true
				returnCardToOrigin()

func returnCardToOrigin():
	$ErrorSound.play()
	collider.disabled = true
	z_index = 0
	create_tween().tween_property(self, "modulate", Color(1,1,1), SPEED)
	create_tween().tween_property(self, "position", card_origin, SPEED)
	create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
	is_dragging = false
	await get_tree().create_timer(SPEED).timeout
	undraggable = false
	

func _on_mouse_entered():
	if not is_dragging and not undraggable:
		z_index = 100
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), SPEED)

func _on_mouse_exited():
	if not is_dragging and not undraggable:
		z_index = 0
		create_tween().tween_property(self, "scale", Vector2(1, 1), SPEED)
