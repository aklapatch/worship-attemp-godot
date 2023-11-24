extends Tree

@onready var root = self.create_item()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var was_hid: bool = true
func _on_hidden():
	was_hid = true
	pass # Replace with function body.


func _on_visibility_changed():
	if was_hid == false:
		return

	# reload the songs if we are becoming visible. 
	# This is sensitive to whether the hidden signal happens before the visibility
	# changed signal or not
	was_hid = false
	var save_dir = "user://services/"
	var dir = DirAccess.open(save_dir)
	if not dir:
		# Make the folder for next time
		DirAccess.make_dir_absolute(save_dir)
		push_error("Couldn't open %s" % save_dir)
		return

	# Delete all the items in the tree before we add items back
	for child in root.get_children():
		child.free()
		
	var files = dir.get_files()
	for file in files:
		if file.ends_with(".json"):
			var file_str = FileAccess.get_file_as_string(save_dir + file)
			var json_obj = JSON.parse_string(file_str)
			
			# Add one tree item per song/set. Add a button for deletion
			var new_item = root.create_child()
			new_item.set_text(0, json_obj['name'])
			new_item.set_editable(0, false)
			# TODO: only import the texture once
			var tex_img = Image.load_from_file('res://delete-icon.png')
			var texture: Texture2D = ImageTexture.create_from_image(tex_img)
			new_item.add_button(0, texture)
			
