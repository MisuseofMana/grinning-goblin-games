extends TextureRect

@onready var counter = $ActionPointsCounter
@onready var particles = $GPUParticles2D

var remaining_ap : int :
	set(newValue):
#		animate to new value from old value
		animateLabelFromTo(newValue, remaining_ap, counter)
		remaining_ap = newValue

func animateLabelFromTo(to: int, from: int, targetNode: Label):
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		targetNode.text = str(incrementer)
		particles.emitting = true
