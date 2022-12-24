extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pic_script = load("res://PicDisplayButtpn.gd")
onready var preview_text_script = load("res://slidetext_preview.gd")
onready var item_list = get_node("../../ScrollContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "make_new_slide")
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func make_new_slide():
	print("New slide")
	# add new nodes to the item list
	var num_children = item_list.get_child_count()
	
	# set the label of the next child to be one more than what's there
	var new_label = LineEdit.new()
	new_label.text = str(num_children/2 + 1) + "."
	new_label.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var new_text_button = TextureButton.new()
	new_text_button.size_flags_horizontal = SIZE_EXPAND_FILL
	new_text_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT
	new_text_button.expand = true
	new_text_button.set_script(pic_script)
	
	# inherit the texture from the previous slide.
	var child_w_texture = item_list.get_children()[num_children - 2]
	new_text_button.texture_normal = child_w_texture.texture_normal
	
	var new_text = RichTextLabel.new()
	new_text.bbcode_enabled = true
	new_text.bbcode_text = "<test text>"
	new_text.size_flags_horizontal = SIZE_EXPAND_FILL
	new_text.size_flags_vertical = SIZE_EXPAND_FILL
	new_text.set_script(preview_text_script)
	
	var new_show_button = Button.new()
	new_show_button.text = "Show"
	
	new_text_button.add_child(new_text)
	
	item_list.add_child(new_label)
	item_list.add_child(new_text_button)
	
	item_list.add_child(new_show_button)
	pass
