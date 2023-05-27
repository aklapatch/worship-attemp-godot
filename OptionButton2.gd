extends OptionButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#onready var preview_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview/ViewportContainer/Viewport/Control/Previewtext")
@onready var preview_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview/Previewtext")
@onready var usr_fonts = []
@onready var res_fonts = []

func load_font_names(path: String):
	var dir = DirAccess.new()
	var err = dir.make_dir_recursive(path)
	var output = []
	if err != OK:
		print("Error %u opening %s" % err, OK)
		return
	if dir.open(path) != OK:
		print("Error opening " + path)
		return
		
	var img_path = ProjectSettings.globalize_path(path)
		
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var file_path = img_path + file_name
				
			if file_name.ends_with('ttf'):
				output.append(file_name)
				
		file_name = dir.get_next()
	return output

func item_changed(new_index):
	# Forward the name of this item to the previewtext
	var font_name = self.get_item_text(new_index)
	
	if res_fonts.has(font_name):
		preview_node.load_font("res://" + font_name)
	elif usr_fonts.has(font_name):
		preview_node.load_font("user://fonts/" + font_name)
	else:
		print("Error loading font!")

# Called when the node enters the scene tree for the first time.
func _ready():
	res_fonts = load_font_names("res://")
	usr_fonts = load_font_names("user://fonts/")
	
	preview_node.load_font("res://" + res_fonts[0])
	for item in res_fonts:
		self.add_item(item)
	
	for font in usr_fonts:
		self.add_item(font)
		
	# Tell the 
	preview_node.get_parent().resize_self()
	
	self.connect("item_selected", Callable(self, "item_changed"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
