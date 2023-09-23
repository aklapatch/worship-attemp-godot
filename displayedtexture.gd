extends TextureRect

@onready var pic_node = get_node('/root/Control/TabContainer/VBoxContainer/ScrollContainer/pic_list')

func _on_slides_display_texture(texture: String):
	self.texture = pic_node.pic_by_names[texture]
	pass # Replace with function body.
