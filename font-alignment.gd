extends OptionButton

signal align_selected(new_align: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	var default_text = self.get_popup().get_item_text(0)
	align_selected.emit(default_text.to_lower())
	pass

func _on_item_selected(index: int):
	var align_text = self.get_popup().get_item_text(index)
	align_selected.emit(align_text.to_lower())
	pass # Replace with function body.
