tool class_name RichTextVCenter extends RichTextEffect

# Syntax: [vcenter px=px#]text that is vertically centered[/vcenter]

# Define the tag name.
var bbcode = "vcenter"

func _process_custom_fx(char_fx):
	char_fx.offset = Vector2.UP * char_fx.env.get("px", 0.0)
	return true
