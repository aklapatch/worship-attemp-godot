extends HFlowContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
onready var pics_found = []
onready var zoom_slider = get_node('../../HFlowContainer/HSlider')
onready var zoom_slider_val = zoom_slider.value

# Called when the node enters the scene tree for the first time.
func _ready():
	#self.vseparation = 10
	#self.hseparation = 10
	# load pictures and add them to this node
	# load from the ~/Pictures dir on windows
	var dir = Directory.new()
	var path = "user://images/"
	var err = dir.make_dir_recursive(path)
	if err != OK:
		print("Error %u opening %s" % err, OK)
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
				
				# insert the picture into the textureRect
				var child = TextureRect.new()
				var pic_size = texture.get_size()
	
				var aspect_ratio = pic_size.x/pic_size.y
				var size = Vector2(zoom_slider.value*aspect_ratio, zoom_slider.value)
		
				child.name = "picture"
				child.expand = true
				child.set_stretch_mode(TextureRect.STRETCH_KEEP_ASPECT)
				child.set_texture(texture)
				child.set_custom_minimum_size(size)
		
				var child_container = VBoxContainer.new()	
				
				var img_label = Label.new()
				img_label.text = file_name
				img_label.set_clip_text(true)

				child_container.add_child(img_label)
				child_container.add_child(child)
				
				add_child(child_container)
				
		file_name = dir.get_next()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom_slider.value != zoom_slider_val:
		zoom_slider_val = zoom_slider.value
		# go through all the children and set their new size
		for child in self.get_children():
			# preserve the aspect ratio from the old pic
			# find the picture and set its size
			var pic_child = child.find_node("picture", true, false)
			if pic_child != null:
				var ratio = pic_child.rect_size.x/pic_child.rect_size.y
				var size = Vector2(zoom_slider_val*ratio, zoom_slider_val)
				pic_child.set_custom_minimum_size(size)
			

