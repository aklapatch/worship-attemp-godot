extends AspectRatioContainer

@onready var parent_ish = get_node("/root/Control/TabContainer/SubViewportContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_sub_viewport_container_resized():
	self.set_size(parent_ish.size)
	pass # Replace with function body.
