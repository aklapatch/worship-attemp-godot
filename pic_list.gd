@tool
extends ItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
@onready var pics_found = []
# TODO: have the zoom slider emit a signal for the value change
@onready var zoom_slider = get_node('../../HFlowContainer/HSlider')
@onready var zoom_slider_val = zoom_slider.value

func load_pics(path: String):
	var dir = DirAccess.open(path)
	var err = dir.make_dir_recursive(path)
	if err != OK:
		print("Error %u opening %s" % err, OK)
		return
		
	var img_path = ProjectSettings.globalize_path(path)
		
	var dir_err = dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	assert(dir_err == OK, "Dir opening failed")
	
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			var file_path = img_path + file_name
			
			# Don't reload duplicate images
			for i in range(0, self.item_count):
				var item_text = self.get_item_text(i)
				if item_text == file_name:
					file_name = dir.get_next()
				
			if file_name.ends_with('png') or file_name.ends_with('jpg'):
				var img = Image.load_from_file(file_path)
				assert(img != null, "ERROR loading " + file_path)
				var texture = ImageTexture.create_from_image(img)
			
				var pic_size = texture.get_size()
	
				var aspect_ratio = pic_size.x/pic_size.y
				var size = Vector2(zoom_slider.value*aspect_ratio, zoom_slider.value)
				
				self.add_item(file_name, texture)
				
		file_name = dir.get_next()

@onready var back_sel = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer5/MenuButton")
func load_self_pics():
	load_pics("user://images/")
	back_sel.get_popup().clear()
	# Set the contents of the image select menu button
	# TODO: Add a bit that udpate 
	for child in get_tree().get_nodes_in_group("media pics"):
		back_sel.add_pic_item(child.get_texture(), "test")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_self_pics()
	var add_pic_button = get_node("../../HFlowContainer/Button")
	add_pic_button.connect("added_img", Callable(self, "load_self_pics"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom_slider.value != zoom_slider_val:
		zoom_slider_val = zoom_slider.value
		# go through all the children and set their new size
		for child in get_tree().get_nodes_in_group("media pics"):
			# preserve the aspect ratio from the old pic
			# find the picture and set its size
			
			var ratio = child.size.x/child.size.y
			var size = Vector2(zoom_slider_val*ratio, zoom_slider_val)
			child.set_custom_minimum_size(size)
			

