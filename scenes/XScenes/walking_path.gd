extends Node2D

@onready var path = $Path2D
@onready var follow = $Path2D/PathFollow2D
@onready var sprite = $Path2D/PathFollow2D/AnimatedSprite2D
var oldPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	oldPosition = sprite.global_position
	print(oldPosition)
	follow.progress = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	follow.progress += 3
	var oldHori = oldPosition[0]
	var oldVert = oldPosition[1]
	var newHori	= sprite.global_position[0]
	var newVert	= sprite.global_position[1]
	
	if (newVert - oldVert) < (newHori - oldHori):
		if newHori > oldHori:
			sprite.play('right')
		if newHori < oldHori:
			sprite.play('left')
	else:
		if newVert > oldVert:
			sprite.play('down')
		if newVert < oldVert: 
			sprite.play('up')

	if oldPosition == sprite.global_position:
		sprite.play('idle')
		sprite.stop()
	
	oldPosition = sprite.global_position
