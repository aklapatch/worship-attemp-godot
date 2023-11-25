extends TextureRect

@onready var pic_node = get_node('/root/Control/TabContainer/VBoxContainer/ScrollContainer/pic_list')
@onready var default_mod = self.self_modulate

func _ready():
	self.self_modulate = Color.TRANSPARENT

@onready var last_texture = ""
func _on_slides_display_texture(texture: String):
	if texture == last_texture:
		# Return so we don't fade the textures out
		# That's noticeable to the user and we don't want that.
		return
		
	last_texture = texture
	
	var mod_tween = self.create_tween()
	# We use two texture rects to fade between the two textures
	# If we're not transparent, we just fade to transparent.
	# If we are transparent, we take the new texture and fade in.
	if self.self_modulate == Color.TRANSPARENT:
		self.texture = pic_node.pic_by_names[texture]
		# Make sure we stay transparent after we take the new texture.
		self.self_modulate = Color.TRANSPARENT
		mod_tween.tween_property(self, "self_modulate", default_mod, .5)
	elif self.self_modulate == default_mod:
		# Only fade out
		mod_tween.tween_property(self, "self_modulate", Color.TRANSPARENT, .5)
	else:
		push_error("Bad modulate value %v" % self.self_modulate)
