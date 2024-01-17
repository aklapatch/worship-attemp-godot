extends OptionButton

signal font_changed(font_name: String)

@onready var all_fonts = {}

func load_fonts(path: String):
	var err = DirAccess.make_dir_recursive_absolute(path)
	var output = []
	if err != OK:
		print("Error %u making %s" % err, path)
		return
	var dir = DirAccess.open(path)
	var files = dir.get_files()
	for file in files:
		if file.ends_with('.ttf'):
			var loaded_font = load(file)
			output.append(loaded_font)
	return output

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the fonts into memory, then have the signal send the font
	var loaded_fonts = load_fonts("res://")
	loaded_fonts.append_array(load_fonts('user://fonts'))
	for font in loaded_fonts:
		var font_name = font.get_font_name() + ' ' + font.get_font_style_name()
		all_fonts[font_name] = font
		self.add_item(font_name)
		
	# Tell the preview node to chose the first font in the menu
	var default_font = self.get_item_text(0)
	font_changed.emit(all_fonts[default_font])

func _on_item_selected(index: int):
	var f_name = self.get_item_text(index)
	font_changed.emit(all_fonts[f_name])

func _on_slides_selected_slide_font_name(name: String):
	for i in self.item_count:
		var i_txt = self.get_item_text(i)
		if i_txt == name:
			self.selected = i
			# If we don't do this, the font displayed will be out of sync with the font select box
			font_changed.emit(all_fonts[name])
			break
		if i == self.item_count - 1:
			push_error("Couldn't find font %s" % name)
