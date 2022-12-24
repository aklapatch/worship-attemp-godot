extends OptionButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var text_edit = get_node("../../../TextEdit")

func item_changed(idx):
	# push the changed item text to the Text Edit node. That node will forward it to the previewtext
	print("changing justification")
	text_edit.set_just_push_text(idx)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("Center")
	self.add_item("Left")
	self.add_item("Right")
	self.connect("item_selected", self, "item_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
