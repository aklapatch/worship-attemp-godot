extends RichTextLabel
func get_font(font_name: String):
	if not FileAccess.file_exists(font_name):
		return null

	return load(font_name)
	
@onready var default_mod = self.self_modulate
@onready var told_to_hide = false
@onready var old_font_size = 0
@onready var old_font = ""

func _on_slides_display_text(words, font_size, font_align, font):
	# Don't do anything if we're getting the same inputs are before
	var new_bbcode = "[p align=" + font_align.to_lower() + "]" + words + "[/p]"
	if new_bbcode == self.text and old_font_size == font_size and old_font == font:
		return
	old_font_size = font_size
	old_font = font
 
	var tween = self.create_tween()
	if told_to_hide:
		tween.tween_property(self, "self_modulate", default_mod, .5).set_trans(Tween.TRANS_LINEAR)
		told_to_hide = false
	elif told_to_hide == false:
		tween.tween_property(self, "self_modulate", Color.TRANSPARENT, .5).set_trans(Tween.TRANS_LINEAR)
		told_to_hide = true
		# We don't need to set the text if we're fading out. return to avoid that.
		return

	if words == null:
		words = ""
	if font_align == null:
		font_align = "center"
	
	self.text = new_bbcode
	
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

func _on_faderdisptexture_resized():
	if old_font_size == null:
		return
	var adjusted_font_size = get_parent().size.y * (float(old_font_size)/100.0)
	self.add_theme_font_size_override("normal_font_size", int(adjusted_font_size))
