extends Node

func animateLabelFromTo(to: int, from: int, labelNode: Label):
	var changeIncrementerBy : int = 1 if to - from > 0 else -1
	var incrementer : int = from
	while incrementer != to :
		incrementer += changeIncrementerBy
		await get_tree().create_timer(0.1).timeout
		labelNode.text = str(incrementer)
