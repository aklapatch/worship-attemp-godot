extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var button_img = Image.new()
	button_img.create(150, 50,false, Image.FORMAT_RGB8)
	button_img.fill_rect(Rect2(0,0,150, 50), Color(0, 0, 0))
	var button_texture = ImageTexture.new()
	button_texture.create_from_image(button_img)
	
	var img = Image.new()
	img.load("res://worship extreme verse edit menu.png")
	
	var text = ImageTexture.new()
	text.create_from_image(img)
	
	var root = self.create_item()
	root.set_icon_max_width(0, 200)
	root.set_icon(0, text)
	for i in range(100):
		var child = self.create_item(root)
	
		child.set_text(0, "test")
		child.set_editable(0, true)
		child.set_icon_max_width(0,200)
		child.add_button(0, button_texture)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
