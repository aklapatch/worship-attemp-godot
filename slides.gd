extends Tree

signal slide_treeitem_selected(item: TreeItem)

signal treeitem_selected(item: TreeItem, is_a_set: bool)

signal selected_slide_text(slide_text: String)

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
	text_slide.set_icon(0, load("res://icon.png"))
	text_slide.set_editable(0, false)
	text_slide.set_editable(1, false)
	text_slide.set_selectable(0, false)
	text_slide.set_selectable(1, false)

func _on_multi_selected(item: TreeItem, column: int, selected: bool):
	# Find the selected item. Only emit the other signal if a slide (non-set) item was selected
	var is_set = item.get_parent() == root
	
	# emit this signal since it's for any item
	treeitem_selected.emit(item, is_set)
	
	# if this is a set, then don't emit the signal
	if is_set:
		return
		
	# Otherwise, emit the signal. Make sure that we get the slide's text
	slide_treeitem_selected.emit(item if item.get_child_count() == 0 else item.get_first_child())
	
	# Emit the text signal if there's text for this node
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('words'):
		selected_slide_text.emit(slide_tex_and_text[item]['words'])
	elif not slide_tex_and_text.has(item) or not slide_tex_and_text[item].has('words'):
		selected_slide_text.emit("")

@onready var view_port = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport")
func _on_preview_changed_background(new_back: Texture2D):
	var selected = self.get_selected()
	if selected == null:
		return

	if selected.get_parent() != root:
		# Get the texture and store it here:
		if not slide_tex_and_text.has(selected):
			slide_tex_and_text[selected] = {}
		slide_tex_and_text[selected].merge({ 'texture' : new_back }, true)
		selected.get_child(0).set_icon(0, view_port.get_texture())

# TODO: Should all the text + textures + alignment be in one place, or should each widget hold it's stuff
# i.e., the font size widget holds the font size for every slide, the texteditor the text for every slide, etc.
# I'm deciding to leave the slides holding everything because when we're saving this, it will be useful to have everything in one place
func _on_text_edit_text_update(new_text):
		# Store the new text So we can get it back later
	var cur_item = self.get_selected()
	if cur_item == null:
		return
		
	if not slide_tex_and_text.has(cur_item):
		slide_tex_and_text[cur_item] = {}
	slide_tex_and_text[cur_item].merge({'words' : new_text}, true)
