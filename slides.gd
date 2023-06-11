extends Tree

# TODO: Set deletion
@onready var root = self.create_item()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide_root = true
	
func _process(delta):
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
		
		
		
	
