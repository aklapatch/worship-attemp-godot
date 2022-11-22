extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_up", self, "button_pressed")
	
	# set the size based on the texture
	resize_self()
	
	connect("item_rect_changed", self, "resize_self")
	pass # Replace with function body.

func button_pressed():
	print("Tex button pressed")
	
func resize_self():
	# change the vertical size to match the aspect ratio of the texture
	# If there is no texture, then the texture will be null
	if self.texture_normal != null:
		var size = self.texture_normal.get_size()
		var aspect_ratio = size.y/size.x
		var width = self.rect_size.x
		var needed_height = int(width*aspect_ratio)
	
		self.rect_min_size.y = needed_height
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
