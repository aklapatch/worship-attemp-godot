extends SpinBox


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var preview_node = get_node("../../../../../../VSplitContainer/Preview/Previewtext")

func val_changed(new_val: float):
	var int_val = int(new_val)
	preview_node.change_font_size(int_val)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rounded = true
	self.min_value = 2
	self.step = 4
	self.max_value = 100
	self.value = 28
	
	self.connect("value_changed", self, "val_changed")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
