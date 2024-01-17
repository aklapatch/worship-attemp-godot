extends RichTextLabel

signal updated_text(new_text: String)

signal update_align(align_id: int)

# The font size widget emits a signal to set this
@onready var percent_font_size: int = 0

# When the text changes in this node, push the font size, type, and the text
# Default to the first node in the slide list
# TODO: how to handle deleted nodes?

@onready var align_str = "center"
@onready var curr_text = ""

# Load new font
func load_font(new_font: Font):
	self.add_theme_font_override("normal_font", new_font)
	
func update_text_or_align(new_text: String, align: String):
	# Add the bbcode tag depending on the alignment
	self.text = "[p align=" + align_str + "]" + new_text + "[/p]"

func _on_font_size_value_changed(new_font_size: float):
	percent_font_size = new_font_size
	var adjusted_font_size = int(get_parent().size.y * (percent_font_size/100.0))
	self.add_theme_font_size_override("normal_font_size", adjusted_font_size)

func _on_preview_item_rect_changed():
	# Re-adjust our font size to match the ratio
	var adjusted_font_size = get_parent().size.y * (float(percent_font_size)/100.0)
	self.add_theme_font_size_override("normal_font_size", int(adjusted_font_size))

func _on_align_select_align_selected(new_align: String):
	align_str = new_align
	update_text_or_align(curr_text, align_str)

func _on_font_select_font_changed(new_font: Font):
	self.add_theme_font_override("normal_font", new_font)	
	update_text_or_align(curr_text, align_str)

func _on_text_edit_text_update(new_text: String):
	curr_text = new_text
	update_text_or_align(curr_text, align_str)
