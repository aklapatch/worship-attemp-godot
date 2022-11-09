extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var add_slide_button = get_node("../HBoxContainer/Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_slide():
	# just add a child for now
	var rect = TextureRect.new()
	var img = Image.new()
	img.load("res://worship extreme verse edit menu.png")
	
	var text = ImageTexture.new()
	text.create_from_im
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
