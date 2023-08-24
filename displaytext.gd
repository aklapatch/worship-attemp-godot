extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_font(font_name: String):
	if not FileAccess.file_exists(font_name):
		return null

	return load(font_name)

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
		self.add_theme_font_size_override("normal_font_size", font_size)
