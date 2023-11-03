extends Window

signal select_next_slide()
signal select_prev_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

func _input(event):
	# TODO: Add arrow key bindings to go to the next and previous slide
	if event.is_action_pressed('ui_close'):
		self.hide()
	elif event.is_action_pressed('ui_next'):
		select_next_slide.emit()
	elif event.is_action_pressed('ui_prev'):
		select_prev_slide.emit()

func _on_present_pressed():
	self.show()

func _on_screen_select_screen_selected(screen_num):
	self.current_screen = screen_num

func _on_window_select_window_mode_sel(mode):
	assert(mode == MODE_EXCLUSIVE_FULLSCREEN or mode == MODE_WINDOWED or mode == MODE_FULLSCREEN, "ERROR, bad mode %d selected" % mode)
	self.mode = mode
