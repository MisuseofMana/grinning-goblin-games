class_name TwoWayDetection extends Area2D

@onready var collision = $CollisionShape2D
@onready var self_owner = get_parent()
@export var target_indicator : Sprite2D

var overlapping_areas : Array[Area2D]

func drop_spot_is_valid() -> bool:
	if overlapping_areas.is_empty():
		return false
	var targetNode = overlapping_areas.front().owner
	if targetNode is UnitTarget and self_owner is CardComponent:
		var selfTarget: bool = targetNode.is_friendly and self_owner.targets_self
		var enemyTarget: bool = not targetNode.is_friendly and not self_owner.targets_self
		return selfTarget or enemyTarget
	return false
	
# when a new overlap occurs on a unit or a card
func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	if drop_spot_is_valid() and self_owner is CardComponent:
		self_owner.modulate = Color(0, 1, 0)
		area.target_indicator.show()
	elif not drop_spot_is_valid() and self_owner is CardComponent:
		self_owner.modulate = Color(1, 0, 0)

# when a card is removed from a unit or an enemy card
func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
	if area.owner is UnitTarget:
		area.target_indicator.hide()
	if overlapping_areas.is_empty() and self_owner is CardComponent:
		self_owner.modulate = Color(1, 1, 1)

func disableTargeting():
	collision.disabled = true
	
func enableTargeting():
	collision.disabled = false
