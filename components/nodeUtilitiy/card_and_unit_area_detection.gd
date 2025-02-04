class_name TwoWayDetection extends Area2D

@onready var collision = $CollisionShape2D
@onready var self_owner = get_parent()

signal new_overlap_acquired(target)
signal target_has_changed()

var overlapping_areas : Array[Area2D]

func drop_spot_is_valid():
	if overlapping_areas.is_empty():
		return false
	var targetNode = overlapping_areas.front().owner
	
	if targetNode is UnitTarget and self_owner is CardComponent:
		var selfTarget: bool = targetNode.is_friendly and self_owner.targets_self
		var enemyTarget: bool = not targetNode.is_friendly and not self_owner.targets_self
		print("enemyTarget ", enemyTarget)
		print("selfTarget ", selfTarget)
		return selfTarget or enemyTarget
	if targetNode is CardComponent:
		print('overlapping another card')
		
# when a new overlap occurs on a unit or a card
func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	if drop_spot_is_valid():
		self_owner.modulate = Color(0, 1, 0)
	elif not drop_spot_is_valid():
		self_owner.modulate = Color(1, 0, 0)
	new_overlap_acquired.emit(overlapping_areas)
	target_has_changed.emit(overlapping_areas[0])

# when a card is removed from a unit or an enemy card
func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
	new_overlap_acquired.emit(overlapping_areas)
	if area.owner is UnitTarget:
		get_tree().call_group("target_indicators", "hide_indicator")
	if overlapping_areas.is_empty():
		self_owner.modulate = Color(1, 1, 1)
			

func disableTargeting():
	collision.disabled = true
	
func enableTargeting():
	collision.disabled = false
