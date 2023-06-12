extends RichTextLabel

@onready var percent_font_size: int = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer3/FontSize").value

# When the text changes in this node, push the font size, type, and the text
# Default to the first node in the slide list
# TODO: how to handle deleted nodes?
@onready var font_select = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer4/font_select")
@onready var align_select = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer2/align_select")

# This needs to be synced with the text alignment button
@onready var align_tag_map = {0 : "center", 1: "left", 2: "right"}
@onready var align_id = align_select.selected
# When a slide is selected, it should push itself to this node

# Load new font
func load_font(font_name: String):
	if not FileAccess.file_exists(font_name):
		return ERR_FILE_NOT_FOUND
		
	var new_font = load(font_name)
	var curr_font_size = self.get_theme_font_size("normal_font_size")
	var new_font_size = curr_font_size
	if new_font_size == 1:
		# Grab the font size from the parent
		new_font_size = get_parent().get_theme_font_size("normal_font_size")
	
	self.add_theme_font_override("normal_font", new_font)
	return OK

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_text_edit_text_changed():
	# Get the new text and update us with it
	# TODO: Save/grab the alignment too
	var new_text: String = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/TextEdit").text
	# Add the bbcode tag depending on the alignment
	self.text = "[p align=" + align_tag_map[align_id] + "]" + new_text + "[/p]"

func _on_font_size_value_changed(new_font_size: float):
	var adjusted_font_size = int(get_parent().size.y * (new_font_size/100))
	self.add_theme_font_size_override("normal_font_size", adjusted_font_size)
	# TODO: have push node connect and disconnect from the signals of the text input and font size select
	#push_node.add_theme_font_size_override("normal_font_size", adjusted_font_size)

func _on_preview_item_rect_changed():
	# Re-adjust our font size to match the ratio
	var adjusted_font_size = int(get_parent().size.y * (float(percent_font_size)/100.0))
	self.add_theme_font_size_override("normal_font_size", adjusted_font_size)

func _on_font_select_item_selected(index: int):
		# Grab the font name and load it
	var font_name: String = font_select.get_item_text(index)
	var rc = load_font("res://%s" % font_name)
	if rc != OK:
		rc = load_font("usr://fonts/%s" % font_name)
		
	if rc != OK:
		push_error("Failed to load font %s" % font_name)
		
	_on_text_edit_text_changed()

func _on_align_select_item_selected(index: int):
	align_id = index
	# Update the text with the new alignment
	_on_text_edit_text_changed()

func _on_slides_slide_treeitem_selected(item: TreeItem):
	# Grab the item's text and show it
	self.text = item.get_text(0)
	pass # Replace with function body.
