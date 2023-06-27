extends SpinBox

# Called when the node enters the scene tree for the first time.
func _ready():
	self.value_changed.emit(self.value)
	pass # Replace with function body.
