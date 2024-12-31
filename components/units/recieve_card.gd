extends Area2D

signal new_overlap_acquired(target)
signal target_has_changed(currentTarget)

var overlapping_areas : Array[Area2D]
var owners_array : Array = []

func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	owners_array.push_front(owner)
	new_overlap_acquired.emit(overlapping_areas[0])
	target_has_changed.emit(owners_array[0])

func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
	owners_array.erase(owner)
	if overlapping_areas.size():
		new_overlap_acquired.emit(overlapping_areas[0])
	else:
		new_overlap_acquired.emit(null)
