extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: see if this is needed for font caching. Doesn't seem necessary now.
@onready var font_dict = {}
@onready var num_lines = 0
@onready var percent_font_size: int = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer3/FontSize").value

# When the text changes in this node, push the font size, type, and the text
# Default to the first node in the slide list
# TODO: how to handle deleted nodes?
@onready var push_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VBoxContainer/ScrollContainer/VBoxContainer/TextureRect/RichTextLabel")
@onready var font_select = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer4/OptionButton2")
# When a slide is selected, it should push itself to this node
	
# push the current font and the font size to the node we are updating
func update_push_node(font: FontFile):
	push_node.add_theme_font_override("normal_font", font)
	
# Load new font
func load_font(font_name: String):
	var new_font = load(font_name)
	var curr_font_size = self.get_theme_font_size("normal_font_size")
	var new_font_size = curr_font_size
	if new_font_size == 1:
		# Grab the font size from the parent
		new_font_size = get_parent().get_theme_font_size("normal_font_size")
	
	self.add_theme_font_override("normal_font", new_font)
	update_push_node(new_font)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(push_node != null)
	num_lines = self.get_visible_line_count()

# Move and resize this child so it fits in the parents texture
func center_self():
	var parent_size = get_parent().size
	var texture_size = get_parent().texture.get_size()
	
	# Figure out the aspect ratio of the texture based on the node size
	var texture_aspect: float = float(texture_size.x) / float(texture_size.y)
	var needed_width = texture_aspect * parent_size.y
	
func _on_text_edit_text_changed():
	# Get the new text and update us with it
	# TODO: Save/grab the alignment too
	var new_text: String = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/TextEdit").text
	self.text = new_text
	push_node.text = new_text
	center_self()

func _on_font_size_value_changed(new_font_size: float):
	percent_font_size = int(new_font_size)
	var adjusted_font_size = get_parent().size.y * percent_font_size
	self.add_theme_font_size_override("normal_font_size", adjusted_font_size)
	# TODO: have push node connect and disconnect from the signals of the text input and font size select
	#push_node.add_theme_font_size_override("normal_font_size", adjusted_font_size)

func _on_preview_item_rect_changed():
	# Re-adjust our font size to match the ratio
	var adjusted_font_size = int(get_parent().size.y * (float(percent_font_size)/100.0))
	self.add_theme_font_size_override("normal_font_size", adjusted_font_size)
	center_self()

func _on_option_button_2_item_selected(index: int):
	# Grab the font name and load it
	var font_name: String = font_select.get_item_text(index)
	load_font("res://" + font_name)
	# if that doesn't work try loading from user
	load_font("usr://fonts/" + font_name)
	pass # Replace with function body.
