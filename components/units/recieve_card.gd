extends Area2D

signal new_overlap_acquired(target)

var overlapping_areas : Array[Area2D]

func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	print(overlapping_areas[0])
	new_overlap_acquired.emit(overlapping_areas[0])

func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
