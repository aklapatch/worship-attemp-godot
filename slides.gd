extends Tree

# TODO: Set deletion
@onready var root = self.create_item()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide_root = true

func _on_new_set_pressed():
	# Create a new node from the root
	var set = self.create_item(root)
	# TODO: Change text based on available slide number
	set.set_text(0, "New set")
	set.set_editable(0, true)
	
func _on_new_slide_pressed():
	# If a set/slide is selected, put this slide after that one
	var selected: TreeItem = self.get_selected()
	if selected == null:
		selected = root.get_first_child()
		
	# See if the selected node is on a certain level 
	var sel_parent = selected.get_parent()
	var is_a_set = sel_parent == root
	var new_root = selected if sel_parent == root else sel_parent
	var index = -1
	if sel_parent != root:
		# See the index of this slide, then go one beyond that
		print("test")
		
		
	var new_slide = self.create_item()
	if is_a_set:
		# Add this to the set
		self.create_item(selected)
	else:
		# Add it right after the selected slide
		self.create_item(sel_parent)
		
		
		
	
