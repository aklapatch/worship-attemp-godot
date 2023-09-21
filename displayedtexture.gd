extends TextureRect

@onready var pic_node = get_node('/root/Control/TabContainer/VBoxContainer/ScrollContainer/pic_list')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_slides_display_texture(texture: String):
	self.texture = pic_node.pic_by_names[texture]
	pass # Replace with function body.
