extends LineEdit

signal save_as(service_name: String)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_saveserviceas_button_up():
	self.save_as.emit(self.text)
	pass # Replace with function body.
