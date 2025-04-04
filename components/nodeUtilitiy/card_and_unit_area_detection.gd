class_name TwoWayDetection extends Area2D

@onready var collision = $CollisionShape2D
@onready var self_owner = get_parent()
@export var target_indicator : Sprite2D

var overlapping_areas : Array[Area2D]

func drop_spot_is_valid() -> bool:
	if overlapping_areas.is_empty():
		return false
	var targetNode = overlapping_areas.front().owner
	if targetNode is BattleUnit:
		var unit : BattleUnit = targetNode
		var targetsSelf = self_owner.card_stats.targets_self and unit.targetingNode.is_ally
		var targetsEnemy = not self_owner.card_stats.targets_self and not unit.targetingNode.is_ally
		return targetsSelf or targetsEnemy
	if targetNode is CardComponent && self_owner is CardComponent:
		var canUseOnCard: bool = targetNode.card_stats.accepts_cards
		var targetAcceptableCards: Array[GDScript] = targetNode.card_stats.accepts_these_card_effects
		var acceptableCounter: bool = targetAcceptableCards.has(self_owner.card_stats.card_effect)
		return canUseOnCard and acceptableCounter
	return false
	
# when a new overlap occurs on a unit or a card
func handle_new_overlap(area : Area2D):
	overlapping_areas.push_front(area)
	if self_owner is CardComponent:
		if self_owner.card_stats.enemy_card:
			return
	if drop_spot_is_valid() and self_owner is CardComponent:
		self_owner.modulate = Color(0, 1, 0)
		if area.owner is BattleUnit:
			area.target_indicator.show()
	elif not drop_spot_is_valid() and self_owner is CardComponent:
		self_owner.modulate = Color(1, 0, 0)

# when a card is removed from a unit or an enemy card
func handle_remove_overlap(area : Area2D):
	overlapping_areas.erase(area)
	if area.owner is BattleUnit:
		area.target_indicator.hide()
	if overlapping_areas.is_empty() and self_owner is CardComponent:
		self_owner.modulate = Color(1, 1, 1)

func disableTargeting():
	collision.disabled = true
	
func enableTargeting():
	collision.disabled = false
