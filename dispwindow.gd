extends Window

signal select_next_slide()
signal select_prev_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

# We need to store the current screen because if we switch it while the screen
# isn't up, it won't take effect.
@onready var perm_screen_num = 1

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
	self.current_screen = perm_screen_num

func _on_screen_select_screen_selected(screen_num):
	perm_screen_num = screen_num
	self.current_screen = perm_screen_num

func _on_window_select_window_mode_sel(new_mode):
	assert(new_mode == MODE_EXCLUSIVE_FULLSCREEN or new_mode == MODE_WINDOWED or new_mode == MODE_FULLSCREEN, "ERROR, bad mode %d selected" % mode)
	self.mode = new_mode
	# This can go to the wrong screen if we don't re-assert the proper screen here.
	self.current_screen = perm_screen_num
