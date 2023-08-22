extends Window


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed('ui_close'):
		self.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_present_pressed():
	self.show()
	pass # Replace with function body.


func _on_slides_push_texture(texture):
	pass # Replace with function body.
