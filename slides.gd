extends Tree

signal slide_treeitem_selected(item: TreeItem)

signal treeitem_selected(item: TreeItem, is_a_set: bool)

signal selected_slide_text(slide_text: String)

signal selected_slide_background(back_text_name: String)

signal selected_slide_font_size(size: int)

signal selected_slide_font_align(align: String)

signal selected_slide_font_name(name: String)

signal display_texture(tex_name: String)

signal display_text(words: String, font_size: int, font_align: String, font_name: String)

# Stores the text for the slide, the alignment, and the texture
var slide_tex_and_text = {}

const icon_t_item = preload("res://cust_treeitem.gd")

# TODO: Set deletion
@onready var root = self.create_item()
@onready var pic_list_node = get_node('/root/Control/TabContainer/VBoxContainer/ScrollContainer/pic_list')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	# TODO: Convert ui_delete to be an action added by add_action and action_add_event
	# I prefer to have the code set something like that up, not sure why. I don't have the philosophy with signals
	if Input.is_action_pressed("ui_delete"):
		# Remove the selected child if one is selected
		var selected = self.get_selected()
		# try to delete the preview viewport
		var prev_node = get_tree().get_first_node_in_group(selected.to_string())
		assert(prev_node != null)
		prev_node.free()
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
	var default_background = pic_list_node.pic_by_names[pic_list_node.default_pic_name].duplicate()
	text_slide.set_icon(0, default_background)
	# Need to put in a space to have the item vertically space itself out
	text_slide.set_icon_max_width(0, 200)
	text_slide.set_editable(0, false)
	text_slide.set_editable(1, false)
	text_slide.set_selectable(0, false)
	text_slide.set_selectable(1, false)
	
	# Set up the parameters for the icon's viewport
	var vp = SubViewport.new()
	vp.disable_3d = true
	vp.size = Vector2(200, 113)
	var t_rect = TextureRect.new()
	t_rect.size = vp.size
	t_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	t_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	t_rect.texture = default_background
		
	var rtl = RichTextLabel.new()
	rtl.bbcode_enabled = true
	rtl.fit_content = true
	rtl.scroll_active = false
	rtl.clip_contents = true
	rtl.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
	# HACK: Setting the anchors preset should set this to one, but it doesn't
	# the enum for this isn't exported, so we need to do this manually for now.
	rtl.layout_mode = 1
	var cur_font_name = font_name.get_item_text(font_name.selected)
	var cur_font = font_name.all_fonts[cur_font_name]
	rtl.add_theme_font_override("normal_font", cur_font)
			
	# TODO: calculate font size based on size of the icon/window
	rtl.add_theme_font_size_override("normal_font_size", font_size.value)

	# Add the bbcode tag depending on the alignment
	var cur_align = font_align.get_item_text(font_align.selected).to_lower()
	rtl.text = "[p align=" + cur_align + "][/p]"
		
	t_rect.add_child(rtl)
	vp.add_child(t_rect)
	# The title is what actually is selected. That means the title needs to be the group
	# UID since we look up the group by what was selected.
	var grp = new_slide.to_string()
	vp.add_to_group(grp)
	# This vp needs to be a child or it won't render.
	self.add_child(vp)
		
	# Set the texture for this dictionary so that the on_multi_selected()
	# doesn't select the currently selected background.
	text_slide.set_icon(0, vp.get_texture())
	text_slide.set_icon_max_width(0, 200)
	
	# Pre-populate the dictionary in case we need to save later
	var slide_words = ""
	var slide_texture = null
	var s_font_size = font_size.value
	var s_font_align = font_align.get_item_text(font_align.selected)
	var s_font_name = font_name.get_item_text(font_name.selected)
	slide_tex_and_text[new_slide] = { 
		'name' : new_slide.get_text(0),
		'words' : slide_words,
		'texture' : pic_list_node.default_pic_name,
		'font_size' : s_font_size,
		'font_align' : s_font_align,
		'font_name' : s_font_name }

var selected_item: TreeItem = null

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
			var prev_node = get_tree().get_first_node_in_group(selected_item.to_string())
			assert(prev_node != null)
			var t_tex_node = prev_node.get_child(0)
			var slide_texture = t_tex_node.texture.resource_path
			var s_font_size = font_size.value
			var s_font_align = font_align.get_item_text(font_align.selected)
			var s_font_name = font_name.get_item_text(font_name.selected)
			var merge_data = {
				'words' : text_edit.text,
				'font_size' : font_size.value,
				'font_align' : s_font_align,
				'font_name' : s_font_name
			}
			
			slide_tex_and_text[selected_item].merge(merge_data, true)

	selected_item = item
	
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

	# Emit the stored texture if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('texture'):
		var tmp_tex = slide_tex_and_text[item]['texture']
		if tmp_tex != null:
			selected_slide_background.emit(tmp_tex)
		
	# Emit the stored font size if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_size'):
		selected_slide_font_size.emit(slide_tex_and_text[item]['font_size'])
		
	# Emit the stored font size if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_align'):
		selected_slide_font_align.emit(slide_tex_and_text[item]['font_align'])
		
	# Emit the stored font name if there is one
	if slide_tex_and_text.has(item) and slide_tex_and_text[item].has('font_name'):
		selected_slide_font_name.emit(slide_tex_and_text[item]['font_name'])

# TODO: Should all the text + textures + alignment be in one place, or should each widget hold it's stuff
# i.e., the font size widget holds the font size for every slide, the texteditor the text for every slide, etc.
# I'm deciding to leave the slides holding everything because when we're saving this, it will be useful to have everything in one place

var last_item_shown: TreeItem = null
func _on_button_clicked(item, column, id, mouse_button_index):
	last_item_shown = item

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
	var save_dir = "user://sets/"
	var result = DirAccess.make_dir_absolute(save_dir)
	if result != OK and result != ERR_ALREADY_EXISTS:
		push_error("Error %s making %s" % [error_string(result), save_dir])
	for child in root.get_children():
		var set_slides = []
		for slide in child.get_children():
			if slide == selected_item:
				# Update the text. Other items should already be in the dictionary.
				if not slide_tex_and_text.has(slide):
					slide_tex_and_text[slide] = {}
					
				var s_font_align = font_align.get_item_text(font_align.selected)
				var s_font_name = font_name.get_item_text(font_name.selected)
				var merge_data = {
					'name' : slide.get_text(0),
					'words' : text_edit.text ,
					'font_size' : font_size.value,
					'font_align' : s_font_align,
					'font_name' : s_font_name }
				slide_tex_and_text[slide].merge(merge_data, true)
				
			set_slides.append(slide_tex_and_text[slide])
		# TODO: only save the texture name
		var json_dict = { 'name' : child.get_text(0), 'slides': set_slides}
		var json_to_write = JSON.stringify(json_dict)
		var file_name = save_dir + child.get_text(0) + ".json"
		print("writing to %s" % file_name)
		if FileAccess.file_exists(file_name):
			# TODO: Ask to overwrite?
			print("%s exists alrady" % file_name)
			print("path=%s" % ProjectSettings.globalize_path(file_name))
		var f_handle = FileAccess.open(file_name, FileAccess.WRITE)
		f_handle.store_string(json_to_write)
		f_handle.close()

func make_set_slides(data: Dictionary):
	# Add the slides as tree items
	var new_set = null
	for item in root.get_children():
		if item.get_text(0) == data['name']:
			# Free the children, so we can re-use the set node.
			for child in item.get_children():
				child.free()
			new_set = item

	if new_set == null:
		new_set = self.create_item(root)
	new_set.set_text(0, data['name'])
	new_set.set_editable(0, true)
	var default_text = load("res://push_icon.png")
	
	var slides = data['slides']
	for slide in slides:
		var new_slide = self.create_item(new_set)
		if slide_tex_and_text.has(new_slide):
			push_error("Overwriting slide! " + new_slide)
			slide_tex_and_text[new_slide].merge(slide, true)
		else:
			slide_tex_and_text[new_slide] = slide
		new_slide.set_text(0, slide['name'])
		new_slide.set_editable(0, true)
		new_slide.add_button(0, default_text)
		# use our custom item so that its viewport will automatically be freed when
		# it is deleted
		# TODO: Attach more data to the icon item, like the font type, size,
		# etc. That will help delete extra data when we free the icon
		# That way we don't need to free it from the dictionary manually 
		var icon_child = new_slide.create_child()
		icon_child.set_selectable(0, false)
		icon_child.set_editable(0, false)

		# Set up the parameters for the icon's viewport
		var vp = SubViewport.new()
		vp.disable_3d = true
		vp.size = Vector2(200, 113)
		var t_rect = TextureRect.new()
		t_rect.size = vp.size
		t_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		t_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		t_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		t_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		t_rect.texture = pic_list_node.pic_by_names[slide['texture']]
		
		var rtl = RichTextLabel.new()
		rtl.bbcode_enabled = true
		rtl.fit_content = true
		rtl.scroll_active = false
		rtl.clip_contents = true
		rtl.set_anchors_preset(Control.PRESET_HCENTER_WIDE)
		# HACK: Setting the anchors preset should set this to one, but it doesn't
		# the enum for this isn't exported, so we need to do this manually for now.
		rtl.layout_mode = 1
		var s_font_name = slide['font_name']
		if s_font_name in font_name.all_fonts:
			var actual_font = font_name.all_fonts[s_font_name]
			rtl.add_theme_font_override("normal_font", actual_font)
		else:
			push_error("Font: %s doesn't exist!" % font_name)
			
		rtl.add_theme_font_size_override("normal_font_size", slide['font_size'])

		# Add the bbcode tag depending on the alignment
		rtl.text = "[p align=" + slide['font_align'].to_lower() + "]" + slide['words'] + "[/p]"
		
		t_rect.add_child(rtl)
		vp.add_child(t_rect)
		# The title is what actually is selected. That means the title needs to be the group
		# UID since we look up the group by what was selected.
		var grp = new_slide.to_string()
		vp.add_to_group(grp)
		# This vp needs to be a child or it won't render.
		self.add_child(vp)
		
		# Set the texture for this dictionary so that the on_multi_selected()
		# doesn't select the currently selected background.
		slide_tex_and_text[new_slide].merge(slide, true)
		icon_child.set_icon(0, vp.get_texture())
		icon_child.set_icon_max_width(0, 200)

# NOTE: I tried to have the signal function that loads the slides block until the
# accpetance dialog was closed, but stopped the whole program. It seems like signals
# can't block. That will probably bit me later. That's why I have to queue the imported
# data in a global variable. There's probably a better way to do this, but I don't
# know what it is right now.
var queued_import = null
func _on_import_set_import_set(data: Dictionary):
	# TODO: Make sure existing sets don't confict with the imported set
	# Probably have a dialog, or renaming box to fix that
	# Switch the slides dictionary to index by slide names instead of item ids
	var set_name = data['name']
	for item in root.get_children():
		if item.get_text(0) == set_name:
			var conf_dialog = self.get_child(0)
			# If this is confirmed, another function will import this.
			queued_import = data
			conf_dialog.show()
			return
	make_set_slides(data)

func _on_menu_button_switch_background(pic_name: String):
	var sel_item = self.get_selected()
	if sel_item == null:
		return
	if not slide_tex_and_text.has(sel_item):
		slide_tex_and_text[sel_item] = {}
	slide_tex_and_text[sel_item]['texture'] = pic_name

# TODO: This doesn't go to the next set from one set to another.
func _on_dispwindow_select_next_slide():
	var next_item: TreeItem = null
	if last_item_shown == null:
		# Start from the beginning if we haven't shown an item yet.
		var r_child = root.get_first_child()
		if r_child != null:
			next_item = r_child.get_first_child()
	else:
		next_item = last_item_shown.get_next()
	
	# Only show slides. If we get a slide that's a set see if we can get to the next set
	if next_item == null:
		var last_parent = last_item_shown.get_parent()
		var next_set = last_parent.get_next()
		if next_set != null:
			next_item = next_set.get_first_child()
		
	if next_item == null:
		# We don't wrap around if we reach the end.
		return
	assert(next_item.get_parent() != root)
	_on_button_clicked(next_item, 0, 0, 0)

func _on_dispwindow_select_prev_slide():
	var next_item: TreeItem = null
	if last_item_shown == null:
		# Start from the beginning if we haven't shown an item yet.
		var r_child = root.get_first_child()
		if r_child != null:
			next_item = r_child.get_first_child()
	else:
		next_item = last_item_shown.get_prev()
	
	# Only show slides. If we get a slide that's a set see if we can get to the next set
	if next_item == null:
		var last_parent = last_item_shown.get_parent()
		var next_set = last_parent.get_prev()
		if next_set != null:
			next_item = next_set.get_child(-1)

	# Only show slides. If we get a slide that's a set just return
	if next_item == null:
		# We don't wrap around if we reach the end.
		return
	assert(next_item.get_parent() != root)
	_on_button_clicked(next_item, 0, 0, 0)

func _on_servicename_save_as(service_name: String):
	# Grab all the set names then put them in a JSON file.
	var sets = []
	for child in root.get_children():
		sets.append(child.get_text(0))
		
	var save_dict = {'name' : service_name, 'sets' : sets}
	var json_str = JSON.stringify(save_dict)
	
	const services_dir: String = "user://services/"
	if not DirAccess.dir_exists_absolute(services_dir):
		var err = DirAccess.make_dir_absolute(services_dir)
		if err != OK:
			push_error("Error %d opening %s." % [err, services_dir])
			# Don't bother if we can't get that folder to exist.
			return
		
	# Try saving anway since the folder might already exist.
	var service_file = FileAccess.open(services_dir + service_name + '.json', FileAccess.WRITE)
	service_file.store_string(json_str)
	service_file.close()

func _on_openservice_import_service(data):
	# Save the current sets, then clear the data and load it.
	_on_button_button_up()
		
	# Grab each set data file, then load it with an existing function
	if data.has('sets') == false:
		push_error("Imported service has not sets!")
		return

	for child in root.get_children():
		child.free()

	for set in data['sets']:
		var set_file = FileAccess.open('user://sets/' + set + '.json', FileAccess.READ)
		var set_data = set_file.get_as_text()
		set_file.close()
		var set_dict = JSON.parse_string(set_data)
		_on_import_set_import_set(set_dict)

func _on_saveserviceas_button_up():
	# Save all the sets when we save the service. That makes sure the user gets
	# The sets they expect when they load the service again.
	_on_button_button_up()
	pass # Replace with function body.


func _on_confirmation_dialog_confirmed():
	assert(queued_import != null, "This should be set before confirming an import")
	make_set_slides(queued_import)

func _on_text_edit_text_update(new_text):
	if selected_item == null:
		return
	if not slide_tex_and_text.has(selected_item):
		slide_tex_and_text[selected_item] = {}
	slide_tex_and_text[selected_item].merge({'words' : new_text}, true)
	
	# Update the node's appearance too.
	var is_set = selected_item.get_parent() == root
	var slide_grp = selected_item.to_string()
	var prev_node = get_tree().get_first_node_in_group(slide_grp)
	assert(prev_node != null)
	var t_tex_node = prev_node.get_child(0)
	var words_node = t_tex_node.get_child(0)
	var t_align = font_align.get_item_text(font_align.selected).to_lower()
	words_node.text = "[p align=" + t_align + "]" + new_text + "[/p]"
	
func _get_drag_data(at_position):
	var item = self.get_item_at_position(at_position)
	if item == null:
		return null
	var parent = item.get_parent()
	var first_level = self.get_root() == parent
	var second_level = self.get_root() == parent.get_parent()
	if not (first_level or second_level):
		return null
	var prev_slides = Tree.new()
	# TOOD: Add this slide or a duplicate to this tree
	prev_slides.hide_root = true
	var prev_root = prev_slides.create_item()
	prev_root.add_child(item)
	set_drag_preview(prev_slides)
	return item
	
func _can_drop_data(at_position, data):
	self.drop_mode_flags = DROP_MODE_INBETWEEN
	var drop_type = self.get_drop_section_at_position(at_position)
	if drop_type == -1 or drop_type == 1:
		return true
	return false
	
func _drop_data(at_position, data):
	var rel_item = self.get_item_at_position(at_position)
	assert(rel_item != null)
	var drop_direction = self.get_drop_section_at_position(at_position)
	assert(drop_direction == -1 or drop_direction == 1)
	
	# -1 is below, and 1 is above
	var item_is_set = rel_item.get_parent() == self.get_root()
	if item_is_set:
		if drop_direction == -1:
			rel_item.move_after(data)
		else:
			rel_item.move_before(data)
	else:
		var set_item = rel_item.get_parent()
		if drop_direction == -1:
			set_item.move_after(data)
		else:
			set_item.move_before(data)
