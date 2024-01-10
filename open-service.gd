extends MenuButton

@onready var services = []

signal import_service(data: Dictionary)

func emit_service(index: int):
	import_service.emit(services[index])
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_popup().connect("index_pressed", Callable(self, "emit_service"))

func _on_about_to_popup():
	const save_dir = "user://services/"
	var dir = DirAccess.open(save_dir)
	if not dir:
		push_error("Couldn't open %s" % save_dir)
		
	services = []
	var files = dir.get_files()
	for file in files:
		if file.ends_with(".json"):
			var file_str = FileAccess.get_file_as_string(save_dir + file)
			var json_obj = JSON.parse_string(file_str)
			services.append(json_obj)
	
	self.get_popup().clear()
	for service in services:
		if service != null and service.has('name'):
			self.get_popup().add_item(service['name'])
