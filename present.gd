extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	# Open the wind
	var present_window = Window.new()
	present_window.always_on_top = true
	present_window.unfocusable = true
	self.add_child(present_window)
	pass # Replace with function body.
