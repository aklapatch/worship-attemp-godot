extends TextEdit

func _on_slides_nothing_selected():
	# Disallow editing when a slide isn't selected
	self.editable = false
	self.text = ""
	pass # Replace with function body.


func _on_slides_treeitem_selected(item: TreeItem, is_a_set: bool):
	if is_a_set:
		self.editable = false
		self.text = ""
	else:
		self.editable = true
		self.text = item.get_child(0).get_text(0)
	pass # Replace with function body.
