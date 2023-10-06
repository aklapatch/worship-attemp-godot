extends OptionButton

signal window_mode_sel(mode)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_item_selected(index):
	window_mode_sel.emit(self.get_item_id(index))
