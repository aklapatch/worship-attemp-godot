extends RichTextLabel
func get_font(font_name: String):
	if not FileAccess.file_exists(font_name):
		return null

	return load(font_name)

# TODO: Add a menu button that changes which screen this thing is on
# That should probably be a popup menu
func _on_slides_display_text(words, font_size, font_align, font):
	if words == null:
		words = ""
	if font_align == null:
		font_align = "center"
		
	self.text = "[p align=" + font_align.to_lower() + "]" + words + "[/p]"
	
	if font != null:
		var new_font = get_font("res://%s" % font)
		if new_font == null:
			new_font = get_font("usr://font/%s" % font)
			
		if new_font == null:
			push_error("Failed to load font %s" % font)
			
		if new_font != null:
			self.add_theme_font_override("normal_font", new_font)
			
	if font_size != null:
		# Get the parent's size and set this to be a percentage of the
		# parent's size
		# NOTE: in the future, we could change the font size based on a signal
		# from the parent, but since the parent window won't change in size much
		# IMO, I won't do that for now.
		var adjusted_font_size = get_parent().size.y * (float(font_size)/100.0)
		self.add_theme_font_size_override("normal_font_size", int(adjusted_font_size))
