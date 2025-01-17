extends Control

@onready var action_points_counter = $ActionPointsCounter
@onready var gpu_particles_2d = $GPUParticles2D

@export var player : UnitSprite

var remaining_ap : int :
	set(newValue):
#		animate to new value from old value
		animateLabelFromTo(newValue, remaining_ap)
		remaining_ap = newValue

func _ready():
	remaining_ap = player.deckNode.hand_size

func reduce_ap_by(howMuch):
	remaining_ap = remaining_ap - howMuch
	
func increase_ap_by(howMuch):
	remaining_ap = remaining_ap + howMuch

func animateLabelFromTo(to: int, from: int):
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		counter.text = str(incrementer)
		particles.emitting = true
