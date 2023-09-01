extends Tree

signal slide_treeitem_selected(item: TreeItem)

signal treeitem_selected(item: TreeItem, is_a_set: bool)

signal selected_slide_text(slide_text: String)

signal selected_slide_background(background: Texture2D)

signal selected_slide_font_size(size: int)

signal selected_slide_font_align(align: String)

signal selected_slide_font_name(align: String)

signal display_texture(texture: Texture2D)

signal display_text(words: String, font_size: int, font_align: String, font_name: String)

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
	var default_text = load("res://push_icon.png")
	new_slide.add_button(0, default_text)
	
	# Create a sub slide to hold the text
	var text_slide = self.create_item(new_slide)

	# Grab the first slide from the slide list
	var background_node = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer5/MenuButton")
	var default_background = background_node.get_popup().get_item_icon(0).duplicate()
	text_slide.set_icon(0, default_background)
		# Need to put in a space to have the item vertically space itself out
	text_slide.set_icon_max_width(0, 200)
	text_slide.set_editable(0, false)
	text_slide.set_editable(1, false)
	text_slide.set_selectable(0, false)
	text_slide.set_selectable(1, false)
	
	# Pre-populate the dictionary in case we need to save later
	var slide_words = ""
	var slide_texture = default_background
	var s_font_size = font_size.value
	var s_font_align = font_align.get_item_text(font_align.selected)
	var s_font_name = font_name.get_item_text(font_name.selected)
	slide_tex_and_text[new_slide] = { 
		'words' : slide_words,
		'texture' : slide_texture,
		'font_size' : s_font_size,
		'font_align' : s_font_align,
		'font_name' : s_font_name }

var selected_item: TreeItem = null

@onready var view_port = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport")
@onready var preview = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport/Preview")
@onready var preview_text = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/AspectRatioContainer/SubViewportContainer/SubViewport/Preview/Previewtext")
@onready var font_size = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer3/FontSize")
@onready var font_align = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer2/align_select")
@onready var text_edit = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/TextEdit")
@onready var font_name = get_node("/root/Control/TabContainer/HBoxContainer/HSplitContainer/VSplitContainer/ScrollContainer/HBoxContainer/HFlowContainer/VBoxContainer4/font_select")

func _on_multi_selected(item: TreeItem, column: int, selected: bool):
	
	if selected == false:
		return
		
	# Find the selected item. Only emit the other signal if a slide (non-set) item was selected
	var is_set = item.get_parent() == root
	
	# emit this signal since it's for any item
	treeitem_selected.emit(item, is_set)
	
	# Save the texture for the old node
	if selected_item != null and selected_item.get_parent() != root:
		var selected_child = selected_item.get_first_child()
		var saved_texture = selected_child.get_icon(0)
		if saved_texture != null:
			selected_child.set_icon(0, ImageTexture.create_from_image(saved_texture.get_image()))
		
		# Grab all the data for this slide:
		# - The text
		# - The texture
		# - The font
		# - The font size
		# - The text alignment
		if selected_item != item:
			var slide_words = text_edit.text 
			var slide_texture = preview.texture
			var s_font_size = font_size.value
			var s_font_align = font_align.get_item_text(font_align.selected)
			var s_font_name = font_name.get_item_text(font_name.selected)
			slide_tex_and_text[selected_item] = { 
				'words' : slide_words,
				'texture' : slide_texture,
				'font_size' : s_font_size,
				'font_align' : s_font_align,
				'font_name' : s_font_name }

	selected_item = item
	
	# if this is a set, then don't emit the signal
	if is_set:
		return
		
	# Set the slide texture to be the viewport
	item.get_first_child().set_icon(0, view_port.get_texture())
	item.get_first_child().set_icon_max_width(0, 200)
		
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
		
	# Emit the stored font size if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_size'):
		selected_slide_font_size.emit(slide_tex_and_text[item]['font_size'])
		
	# Emit the stored font size if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_align'):
		selected_slide_font_align.emit(slide_tex_and_text[item]['font_align'])

# TODO: Should all the text + textures + alignment be in one place, or should each widget hold it's stuff
# i.e., the font size widget holds the font size for every slide, the texteditor the text for every slide, etc.
# I'm deciding to leave the slides holding everything because when we're saving this, it will be useful to have everything in one place


func _on_button_clicked(item, column, id, mouse_button_index):
	
	if item == selected_item:
		var slide_words = text_edit.text 
		var slide_texture = preview.texture
		var s_font_size = font_size.value
		var s_font_align = font_align.get_item_text(font_align.selected)
		var s_font_name = font_name.get_item_text(font_name.selected)
		
		self.display_texture.emit(slide_texture.duplicate())
		self.display_text.emit(slide_words, s_font_size, s_font_align, s_font_name)
		return

	# Grab the texture from this item and emit it as a signal
	var emitted_tex = slide_tex_and_text[item]['texture']
	self.display_texture.emit(emitted_tex.duplicate())
	
	# Get all the info and emit it if we have it
	var s_words = null
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('words'):
		s_words = slide_tex_and_text[item]['words']
	var s_font_size = null
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_size'):
		s_font_size = slide_tex_and_text[item]['font_size']
	var s_font_align = null
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_align'):
		s_font_align = slide_tex_and_text[item]['font_align']
	var s_font_name = null
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_name'):
		s_font_name = slide_tex_and_text[item]['font_name']
		
	self.display_text.emit(s_words, s_font_size, s_font_align, s_font_name)


func _on_button_button_up():
	# var json_str = JSON.stringify(data_to_use)
	var save_dir = "user://sets/"
	var result = DirAccess.make_dir_absolute(save_dir)
	if result != OK and result != ERR_ALREADY_EXISTS:
		push_error("Error %s making %s" % [error_string(result), save_dir])
	for child in root.get_children():
		var set_slides = []
		for slide in child.get_children():
			if slide == selected_item:
				var slide_words = text_edit.text 
				var slide_texture = preview.texture
				var s_font_size = font_size.value
				var s_font_align = font_align.get_item_text(font_align.selected)
				var s_font_name = font_name.get_item_text(font_name.selected)
				slide_tex_and_text[slide] = { 
				'words' : slide_words,
				'texture' : slide_texture,
				'font_size' : s_font_size,
				'font_align' : s_font_align,
				'font_name' : s_font_name }
				
			set_slides.append(slide_tex_and_text[slide])
		# TODO: only save the texture name
		var json_to_write = JSON.stringify(set_slides)
		var file_name = save_dir + child.get_text(0) + ".json"
		print("writing to %s" % file_name)
		if FileAccess.file_exists(file_name):
			# TODO: Ask to overwrite?
			print("%s exists alrady" % file_name)
			print("path=%s" % ProjectSettings.globalize_path(file_name))
		var f_handle = FileAccess.open(file_name, FileAccess.WRITE)
		f_handle.store_string(json_to_write)
		f_handle.close()
