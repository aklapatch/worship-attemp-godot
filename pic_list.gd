extends ItemList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# TODO: have the zoom slider emit a signal for the value change
@onready var zoom_slider = get_node('../../HFlowContainer/HSlider')

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
			var item_text = ""
			for i in range(0, self.item_count):
				item_text = self.get_item_text(i)
				if item_text == file_name:
					break
			if item_text == file_name:
				file_name = dir.get_next()
				continue
				
			if file_name.ends_with('png') or file_name.ends_with('jpg'):
				var img = Image.load_from_file(file_path)
				assert(img != null, "ERROR loading " + file_path)
				var texture = ImageTexture.create_from_image(img)
				
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
	assert(zoom_slider.value_changed.connect(update_icon_scale) == OK, "ERROR connecting signal")
	update_icon_scale(zoom_slider.value)

func update_icon_scale(val: float):
	var int_val = int(val)
	self.fixed_icon_size = Vector2i(int_val, int_val)
	self.queue_redraw()

