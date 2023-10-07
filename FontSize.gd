extends SpinBox

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value_changed.emit(self.value)


func _on_slides_selected_slide_font_size(size):
	# This automatically emits the value changed signal
	self.set_value(float(size))
