extends OptionButton

@onready var usr_fonts = []
@onready var res_fonts = []

func load_font_names(path: String):
	var dir = DirAccess.open(path)
	var err = dir.make_dir_recursive(path)
	var output = []
	if err != OK:
		print("Error %u opening %s" % err, OK)
		return
		
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with('ttf'):
				output.append(file_name)
				
		file_name = dir.get_next()
	return output

# Called when the node enters the scene tree for the first time.
func _ready():
	res_fonts = load_font_names("res://")
	usr_fonts = load_font_names("user://fonts/")

	for item in res_fonts:
		self.add_item(item)
	
	for font in usr_fonts:
		self.add_item(font)
		
	# Tell the preview node to chose the first font in the menu
	self.item_selected.emit(0)
