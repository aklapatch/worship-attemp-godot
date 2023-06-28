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


func _on_slides_selected_slide_font_align(align):
	# Find this in the options, throw an error if it doesn't have it
	for i in range(0, self.item_count):
		var item_text = self.get_popup().get_item_text(i)
		if align == item_text:
			self.selected = i
			_on_item_selected(i)
			break
