extends Node

var activeDragItemType : String = ''
var activeDragItemLevel : int = 0
var activeDragItemTexture : Texture2D
var itemIsBeingDragged : bool = false
var discardNumber : int = 0

var displayUnit : Dictionary = {
	'type': '',
	'level':'',
	'max': '',
}
