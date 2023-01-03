extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():	
	# set the size based on the texture
	resize_self()
	
	self.connect("item_rect_changed", self, "resize_self")
	# TODO: add code to grab the text from the nested RightText label and push it to the preview
	
func resize_self():
	# change the vertical size to match the aspect ratio of the texture
	# If there is no texture, then the texture will be null
	if self.texture != null:
		var size = self.texture.get_size()
		var aspect_ratio = size.y/size.x
		var width = self.rect_size.x
		var needed_height = int(width*aspect_ratio)
	
		self.rect_min_size.y = needed_height
		
		# resize the child too
		var prev_text = get_child(0)
		prev_text.rect_min_size.y = needed_height
		prev_text.rect_min_size.x = width
