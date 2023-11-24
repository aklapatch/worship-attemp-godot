extends ItemList

signal loaded_pics(pics_names: Dictionary)

# TODO: add a default texture name
@onready var default_pic_name = "cropped-car-landscape.jpg"
@onready var pic_by_names: Dictionary = {}
@onready var zoom_slider = get_node('../../HFlowContainer/HSlider')

# TODO: add a way to delete pictures

func load_pics(path: String):
	var dir = DirAccess.open(path)
	var err = dir.make_dir_recursive(path)
	if err != OK:
		print("Error %u opening %s" % err, OK)
		return
		
	var img_path = ProjectSettings.globalize_path(path)	
	var files = dir.get_files()
	var ret: Dictionary = {}
	for file in files:
		var file_path = img_path + file

		if file.ends_with('.png') or file.ends_with('.jpg'):
			var img = Image.load_from_file(file_path)
			# NOTE: This image loading process strips the resource
			# name and path, which we don't want because we want to be able
			# to reference the image by name when loading slides from disk
			# We'll store them in a dictionary to mitigate that
			assert(img != null, "ERROR loading " + file_path)
			var texture = ImageTexture.create_from_image(img)
			ret[file] = texture
			var new_sz = ret.size()
			self.add_item(file, texture)
	return ret

@onready var back_sel = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer5/MenuButton")
func load_self_pics():
	pic_by_names = load_pics("user://images/")
	if not pic_by_names.has(default_pic_name):
		for pic_name in pic_by_names:
			default_pic_name = pic_name
			break
	self.loaded_pics.emit(pic_by_names)

# Called when the node enters the scene tree for the first time.
func _ready():
	load_self_pics()
	update_icon_scale(zoom_slider.value)

func update_icon_scale(val: float):
	var int_val = int(val)
	self.fixed_icon_size = Vector2i(int_val, int_val)
	self.queue_redraw()

func _on_addpicbutton_added_img():
	load_self_pics()
