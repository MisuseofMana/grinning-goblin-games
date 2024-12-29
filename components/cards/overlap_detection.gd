extends Area2D

var overlapping_areas : Array[Area2D] = []

signal overlaps_changed(overlaps : Array[Area2D])

func overlap_something(area : Area2D):
	overlapping_areas.push_front(area)
	overlaps_changed.emit(overlapping_areas)
	
func unoverlap_something(area : Area2D):
	overlapping_areas.erase(area)
	overlaps_changed.emit(overlapping_areas)
