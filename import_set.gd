extends MenuButton

signal import_set(data: Dictionary)

func emit_set(index: int):
	import_set.emit(sets[index])
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().connect("index_pressed", Callable(self, "emit_set"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@onready var sets = []

func _on_about_to_popup():
	var save_dir = "user://sets/"
	var dir = DirAccess.open(save_dir)
	if not dir:
		push_error("Couldn't open %s" % save_dir)
		
	sets = []
	var files = dir.get_files()
	for file in files:
		if file.ends_with(".json"):
			var file_str = FileAccess.get_file_as_string(save_dir + file)
			var json_obj = JSON.parse_string(file_str)
			sets.append(json_obj)
	
	self.get_popup().clear()
	for set in sets:
		self.get_popup().add_item(set['name'])

	pass # Replace with function body.
