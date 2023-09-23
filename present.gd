extends Button

func _on_pressed():
	# Open the wind
	var present_window = Window.new()
	present_window.always_on_top = true
	present_window.unfocusable = true
	self.add_child(present_window)
	pass # Replace with function body.
