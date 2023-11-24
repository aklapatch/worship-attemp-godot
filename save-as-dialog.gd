extends AcceptDialog


@onready var save_name_line: LineEdit = LineEdit.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	self.register_text_enter(save_name_line)
	pass # Replace with function body.


func _on_saveserviceas_button_up():
	self.popup()
	pass # Replace with function body.
