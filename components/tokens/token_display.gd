extends GridContainer

@onready var grid = $"."

const COUNTER_ITEM = preload("res://components/tokens/token.tscn")

const token_resources = {
	"ARMOR": preload("res://components/tokens/TokenDictionary/TokenTypes/armor.tres"),
	"POISON": preload("res://components/tokens/TokenDictionary/TokenTypes/poison.tres"),
	"WARD": preload("res://components/tokens/TokenDictionary/TokenTypes/ward.tres"),
}

func updateTokens(token_list):
	for child in grid.get_children():
		child.queue_free()
	for key in token_list:
		var newCounter : Token = COUNTER_ITEM.instantiate()
		newCounter.token_stats = token_resources[key]
		newCounter.tokenValue = token_list[key]
		grid.add_child(newCounter)
		newCounter.scale = Vector2(0.5, 0.5)
