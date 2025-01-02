extends Area2D

signal new_overlap_acquired(target)
signal target_has_changed()

var overlapping_areas : Array[Area2D]
var owners_array : Array = []

# when a new overlap occurs on a unit or a card
func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	new_overlap_acquired.emit(overlapping_areas)
	target_has_changed.emit()

# when a card is removed from a unit or an enemy card
func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
	new_overlap_acquired.emit(overlapping_areas)
	if overlapping_areas.size() == 0:
		if owner is not UnitSprite:
			get_tree().call_group("target_indicators", "hide_indicator")
