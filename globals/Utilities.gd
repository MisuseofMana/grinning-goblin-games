extends Node

var current_animations : Dictionary

func animateLabelFromTo(to: int, from: int, labelNode: Label):
	var identifier = labelNode.name
	var uid = str(to)+str(from)+labelNode.name
	if current_animations.has(identifier):
		if current_animations[identifier].has('last_run'):
			current_animations[identifier][current_animations[identifier]['last_run']] = false
	else:
		current_animations[identifier] = {
			'last_run': uid,
			uid: true
		}

	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	var incrementer : int = from
	while incrementer != to:
		if current_animations.has(identifier):
			if current_animations[identifier].has(uid):
				if current_animations[identifier][uid] == false and uid == current_animations[identifier]['last_run']:
					break
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		labelNode.text = str(incrementer)
	current_animations[identifier].erase(uid)
