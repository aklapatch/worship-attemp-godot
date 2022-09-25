extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var pics_found = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# load pictures and add them to this node
	# load from the ~/Pictures dir on windows
	var dir = Directory.new()
	var path = "user://images/"
	var err = dir.make_dir_recursive(path)
	if err != OK:
		print("Error %u opening %s" % err, path)
		return
	if dir.open(path) != OK:
		print("Error opening " + path)
		return
		
	# open the path in an editor
	var img_path = ProjectSettings.globalize_path(path)
	print("img path " + img_path)
	#OS.shell_open(img_path)
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			print("Found directory: " + file_name)
		else:
			var file_path = img_path + file_name
			print("Found file: " + file_path)
			if file_name.ends_with('png') or file_name.ends_with('jpg'):
				print("Loading " + file_path)
				var img = Image.new()
				img.load(file_path)
				var texture = ImageTexture.new()
				texture.create_from_image(img)
				pics_found.push_back(texture)
		file_name = dir.get_next()
	
	for pic in pics_found:
		var child = TextureRect.new()
		var pic_size = pic.get_size()
	
		var aspect_ratio = pic_size.x/pic_size.y
		
		var size = Vector2(250*aspect_ratio, 250)
		
		child.name = "Child"
		child.expand = true
		child.set_stretch_mode(TextureRect.STRETCH_SCALE)
		child.set_texture(pic)
		child.set_custom_minimum_size(size)
		
		var child_container = AspectRatioContainer.new()
		child_container.set_ratio(aspect_ratio)
		
		child_container.add_child(child)
		add_child(child_container)
	
	print("done")

func _process(delta):
	var slider_val = get_node('../../HFlowContainer/HSlider').value
	var children = self.get_children()
	# go through all the children and set their new size
	for child in children:
		child.set_custom_minimum_size(slider_val)
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# this will need to spawn contents based on the images we have loaded.
