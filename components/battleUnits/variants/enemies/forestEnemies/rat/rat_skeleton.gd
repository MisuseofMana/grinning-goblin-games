extends Node2D
class_name UnitAnimation

@onready var a = $AnimationPlayer

func playDie():
	a.play('die')
	
func playAttack():
	a.play('attack')
	
func playHurt():
	a.play('hurt')
	
func playIdle():
	a.play('idle')


func _on_animation_player_animation_finished(anim_name):
	if ['hurt, attack'].has(anim_name):
		playIdle()
