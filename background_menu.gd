extends MenuButton

@onready var prev_tex_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview")
@onready var prev_text_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/Preview/Previewtext")

func send_img_to_preview(index: int):
	var item_tex = self.get_popup().get_item_icon(index)
	var orig_tex = item_tex.duplicate()
	prev_tex_node.set_texture(orig_tex)
	# set the push node too
	assert(prev_text_node != null)
	prev_text_node.push_node.get_parent().set_texture(orig_tex)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().hide_on_item_selection = true
	self.get_popup()
	self.get_popup().connect("index_pressed", Callable(self, "send_img_to_preview"))
	pass # Replace with function body.

func add_pic_item(texture: ImageTexture, label: String):
	# Set the texture to the right size after copying it
	var img_tex = texture.duplicate()
	
	var img_w = img_tex.get_width()
	var img_h = img_tex.get_height()

	var max_dim = max(img_w, img_h)
	var bigger_h = false if int(max_dim) == img_w else true
	
	var scale_factor = 100.0/max_dim
	var new_h = 100 if bigger_h else float(img_h)*scale_factor
	var new_w = 100 if not bigger_h else float(img_w)*scale_factor
	
	var new_size = Vector2i(new_w, new_h)
	img_tex.set_size_override(new_size)
	self.get_popup().add_icon_item(img_tex, label)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
