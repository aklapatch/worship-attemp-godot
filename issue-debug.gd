extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var rel_img_path = "user://images/" + file_name
	var img = Image.load_from_file(rel_img_path)
	print(img)
	assert(img != null, "ERROR: ")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
