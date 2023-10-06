extends OptionButton

signal screen_selected(screen_num: int)


# TODO: Re-sample the number of displays whenevere someone clicks on the menu
# Called when the node enters the scene tree for the first time.
func _ready():
	var s_num = DisplayServer.get_screen_count()
	for i in s_num:
		self.add_item("%d" % (i + 1))
	pass # Replace with function body.

func _on_item_selected(index):
	screen_selected.emit(index)
	pass # Replace with function body.
