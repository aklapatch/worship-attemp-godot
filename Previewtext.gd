extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: see if this is needed for font caching. Doesn't seem necessary now.
@onready var font_dict = {}
@onready var num_lines = 0

# When the text changes in this node, push the font size, type, and the text
# Default to the first node in the slide list
# TODO: how to handle deleted nodes?
@onready var push_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VBoxContainer/ScrollContainer/VBoxContainer/TextureRect/RichTextLabel")
# When a slide is selected, it should push itself to this node
	
func update_text(new_text):
	self.text = new_text
	push_node.text = new_text
	
# push the current font and the font size to the node we are updating
func update_push_node(font: FontFile):
	push_node.add_theme_font_override("normal_font", font)
	push_node.get_parent().change_font_size(get_parent().font_size)
	
# Load new font
func load_font(font_name: String):
	var new_font = load(font_name)
	var curr_font_size = self.get_theme_font_size("normal_font_size")
	var new_font_size = curr_font_size
	if new_font_size == 1:
		# Grab the font size from the parent
		new_font_size = get_parent().get_theme_font_size("normal_font_size")
	
	self.add_theme_font_override("normal_font", new_font)
	get_parent().change_font_size(new_font_size)
	update_push_node(new_font)

func change_font_size(font_size: int):
	var curr_font_size = self.get_theme_font_size("normal_font")
	if curr_font_size == 1:
		return
	curr_font_size = font_size
	self.add_theme_font_size_override("normal_font_size", font_size)
	var curr_font = self.get_theme_font("normal_font_size")
	update_push_node(curr_font)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(push_node != null)
	num_lines = self.get_visible_line_count()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_num_lines = self.get_visible_line_count()
	if new_num_lines != num_lines:
		num_lines = new_num_lines
		
		# use the font size to get the size we are total
		# TODO: Update for a null custom font
		var curr_font_size = self.get_theme_font_size("normal_font_size")
		if curr_font_size == 1:
			return
		var tot_y = curr_font_size * num_lines
		# find the center of the parent vertically
		var parent_y = self.get_parent_area_size().y
		var parent_x = self.get_parent_area_size().x
		var parent = self.get_parent()
		
		var par_center = parent_y/2
		
		var move_here = par_center - tot_y/2
		self.position.y  = move_here
