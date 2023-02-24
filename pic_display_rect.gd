extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"\
onready var text_preview = get_child(0)
onready var font_size: int = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer3/FontSize").value

# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
	# set the size based on the texture
	resize_self()
	
	self.connect("item_rect_changed", self, "resize_self")
	# TODO: add code to grab the text from the nested RightText label and push it to the preview
	
func change_font_size(new_size: int):
	font_size = new_size
	resize_self()
	
func resize_self():
	var curr_font = text_preview.get("custom_fonts/normal_font")
	if curr_font != null:
		curr_font.size = float(font_size)/100.0 * float(self.rect_size.y)
		text_preview.set("custom_fonts/normal_font", curr_font)
	
	# change the vertical size to match the aspect ratio of the texture
	# If there is no texture, then the texture will be null
	if self.texture != null:
		var size = self.texture.get_size()
		if size.y == 0 or size.x == 0:
			return
		var aspect_ratio = size.y/size.x
		var width = self.rect_size.x
		var needed_height = int(width*aspect_ratio)
	
		self.rect_min_size.y = needed_height
		
		# resize the child too
		var prev_text = get_child(0)
		prev_text.rect_min_size.x = width
