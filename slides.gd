extends Tree

signal slide_treeitem_selected(item: TreeItem)

signal treeitem_selected(item: TreeItem, is_a_set: bool)

signal selected_slide_text(slide_text: String)

signal selected_slide_background(background: Texture2D)

# Stores the text for the slide, the alignment, and the texture
var slide_tex_and_text = {}

# TODO: Set deletion
@onready var root = self.create_item()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	# TODO: Convert ui_delete to be an action added by add_action and action_add_event
	# I prefer to have the code set something like that up, not sure why. I don't have the philosophy with signals
	if Input.is_action_pressed("ui_delete"):
		# Remove the selected child if one is selected
		var selected = self.get_selected()
		if selected != null:
			selected.free()

func _on_new_set_pressed():
	# Create a new node from the root
	var new_set = self.create_item(root)
	new_set.set_text(0, "New set %d" % root.get_child_count())
	new_set.set_editable(0, true)
	
func _on_new_slide_pressed():
	# If a set/slide is selected, put this slide after that one
	var selected: TreeItem = self.get_selected()
	if selected == null:
		selected = root.get_first_child()
		if selected == null:
			# Create a new root if necessary
			_on_new_set_pressed()
			selected = root.get_first_child()
		
	# See if the selected node is on a certain level 
	var sel_parent = selected.get_parent()
	var new_root = selected if sel_parent == root else sel_parent
	var index = -1
	if sel_parent != root:
		# See the index of this slide, then go one beyond that
		index = selected.get_index() + 1
		
	var new_slide = self.create_item(new_root, index)
	new_slide.set_text(0, "New Slide %d" % new_root.get_child_count())
	new_slide.set_editable(0, true)
	new_slide.set_editable(1, false)
	
	# Create a sub slide to hold the text
	var text_slide = self.create_item(new_slide)
	# Need to put in a space to have the item vertically space itself out
	text_slide.set_icon_max_width(0, 160)
	# Grab the first slide from the slide list
	var background_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer5/MenuButton")
	var default_background = background_node.get_popup().get_item_icon(0)
	text_slide.set_icon(0, default_background)
	text_slide.set_editable(0, false)
	text_slide.set_editable(1, false)
	text_slide.set_selectable(0, false)
	text_slide.set_selectable(1, false)

var selected_item: TreeItem = null

@onready var view_port = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport")
@onready var preview = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport/Preview")
@onready var preview_text = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport/Preview/Previewtext")
@onready var font_size = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer3/FontSize")
@onready var font_align = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer2/align_select")

func _on_multi_selected(item: TreeItem, column: int, selected: bool):
	# Find the selected item. Only emit the other signal if a slide (non-set) item was selected
	var is_set = item.get_parent() == root
	
	# emit this signal since it's for any item
	treeitem_selected.emit(item, is_set)
	
	# Save the texture for the old node
	if selected_item != null and not is_set:
		var selected_child = selected_item.get_first_child()
		var saved_texture = selected_child.get_icon(0).get_image()
		selected_child.set_icon(0, ImageTexture.create_from_image(saved_texture))
		
		# Grab all the data for this slide:
		# - The text
		# - The texture
		# - The font
		# - The font size
		# - The text alignment
		if not slide_tex_and_text.has(selected):
			slide_tex_and_text[selected] = {}
		
		
	selected_item = item
	
	# if this is a set, then don't emit the signal
	if is_set:
		return
		
	# Set the slide texture to be the viewport
	item.get_first_child().set_icon(0, view_port.get_texture())
		
	# Otherwise, emit the signal. Make sure that we get the slide's text
	slide_treeitem_selected.emit(item if item.get_child_count() == 0 else item.get_first_child())
	
	# Emit the text signal if there's text for this node
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('words'):
		selected_slide_text.emit(slide_tex_and_text[item]['words'])
	elif not slide_tex_and_text.has(item) or not slide_tex_and_text[item].has('words'):
		selected_slide_text.emit("")

	# Emit the stored texture if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('texture'):
		selected_slide_background.emit(slide_tex_and_text[item]['texture'])


# TODO: Should all the text + textures + alignment be in one place, or should each widget hold it's stuff
# i.e., the font size widget holds the font size for every slide, the texteditor the text for every slide, etc.
# I'm deciding to leave the slides holding everything because when we're saving this, it will be useful to have everything in one place
