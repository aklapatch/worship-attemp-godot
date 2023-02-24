extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var preview_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview")
onready var preview_text_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview/Previewtext")
onready var text_edit_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/TextEdit")

func strip_bbcode(source:String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "push_edit_slide")

func push_edit_slide():
	# Grab the node behind us with text and textures
	var hbox = self.get_parent()
	var scroll_vbox = hbox.get_parent()
	var hbox_idx = hbox.get_position_in_parent()
	var text_rect = scroll_vbox.get_children()[hbox_idx - 1]
	var text_show_rect = text_rect.get_children()[0]
	
	# Push the properties of this node to the preview node (font, texture, etc.)
	preview_node.texture = text_rect.texture
	
	preview_text_node.bbcode_text = text_show_rect.bbcode_text
	# update the text edit node too
	text_edit_node.text = strip_bbcode(text_show_rect.bbcode_text)
	
	# TODO: update the font sliders and font size button
	# TODO: If the font is null, then inherit from the font size and font options
	var slide_font = text_show_rect.get("custom_fonts/normal_font")
	if slide_font != null:
		preview_text_node.set("custom_fonts/normal_font", slide_font)
	preview_text_node.push_node = text_show_rect
