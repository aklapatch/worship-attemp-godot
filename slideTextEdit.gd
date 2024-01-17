extends TextEdit

signal text_update(new_text: String)

func _on_slides_nothing_selected():
	# Disallow editing when a slide isn't selected
	self.editable = false
	self.text = ""

func _on_text_changed():
	text_update.emit(self.text)

func _on_slides_selected_slide_text(slide_text):
	self.editable = true
	self.text = slide_text
	_on_text_changed()

func _on_slides_treeitem_selected(item, is_a_set):
	# Mark as not editable if the user selects a set not a slide
	if is_a_set:
		self.editable = false
