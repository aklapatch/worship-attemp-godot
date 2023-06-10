extends RichTextLabel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var num_lines = 0
@onready var prev_text = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/Preview/Previewtext")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.bbcode_enabled = true
	self.size_flags_horizontal = SIZE_EXPAND_FILL | SIZE_SHRINK_CENTER
	self.size_flags_vertical = SIZE_SHRINK_CENTER
	self.scroll_active = false
	self.fit_content = true
	num_lines = self.get_visible_line_count()
	
	# Grab the current font of the preview window and use that
	var font = prev_text.get("theme_override_fonts/normal_font")
	if font != null:
		self.set("theme_override_fonts/normal_font", font)

func _process(delta):
	var new_num_lines = self.get_visible_line_count()
	if new_num_lines != num_lines:
		num_lines = new_num_lines
		
		var font_size = self.get_theme_font_size("normal_font_size")
		if font_size == 1:
			# Return if no valid font_size is set
			return
		# use the font size to get the size we are total
		var tot_y = font_size * num_lines
		
		# find the center of the parent vertically
		var parent_y = self.get_parent_area_size().y
		var parent_x = self.get_parent_area_size().x
		var parent = self.get_parent()
		
		var par_center = parent_y/2
		
		var move_here = par_center - tot_y/2
		self.position.y  = move_here
