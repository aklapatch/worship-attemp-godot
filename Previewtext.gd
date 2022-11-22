extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var font_dict = {}
onready var curr_font = DynamicFont.new()

# Load new font
func load_font(font_name):
	var new_font = DynamicFont.new()
	new_font.font_data = load(font_name)
	new_font.size = curr_font.size
	
	curr_font = new_font
	
	self.set("custom_fonts/normal_font", curr_font)
		
func change_font_size(font_size: int):
	curr_font.size = font_size
	self.set("custom_fonts/normal_font", curr_font)

# Called when the node enters the scene tree for the first time.
func _ready():
	curr_font.size = 20
	self.install_effect(load('res://vcenter.gd'))
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
