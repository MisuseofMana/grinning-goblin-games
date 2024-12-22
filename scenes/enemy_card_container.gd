extends Node2D
class_name EnemyCardContainer

@onready var area_2d = $Path2D/PathFollow2D/EnemyCardTemplate/Area2D
@onready var enemy_card_template : CardImage = $Path2D/PathFollow2D/EnemyCardTemplate
@onready var anims = $EnemyCardAnimations

@onready var accept_effect = $AcceptEffect

func _on_accept_effect_pressed():
	enemy_card_template.runCardEffect()
	accept_effect.hide()

func _on_enemy_card_template_enemy_card_accepted():
	anims.play('evaporate')

func _on_enemy_card_animations_animation_finished(anim_name):
	if anim_name == 'fly_in':
		accept_effect.show()
