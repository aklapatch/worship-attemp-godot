extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var fd = FileDialog.new()
onready var user_path = ProjectSettings.globalize_path("user://")


# yoinked from https://www.reddit.com/r/godot/comments/pc45q4/hacky_way_to_get_a_native_file_dialog_on_windows/
# Give it an Array of valid PS commands
func exec_script(ps_script : Array) -> Array:
	
	var ps_concat = "& { "
	for line in ps_script:
		ps_concat += line + '\n'
	ps_concat += "}"

	var output = []
	print(ps_concat)
	OS.execute("powershell.exe", ["-Command", ps_concat], true, output)
	
	return output

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_button_pressed")

func _button_pressed():
	#fd.popup_centered_minsize(Vector2(100,100))
	var ps_script_folder = [
	"Add-Type -AssemblyName System.Windows.Forms",
	"$FolderDialog = New-Object -Typename System.Windows.Forms.FolderBrowserDialog",
	"[void]$FolderDialog.ShowDialog()",
	"$FolderDialog.SelectedPath"
	]

	var ps_script_file = [
	"Add-Type -AssemblyName System.Windows.Forms",
	"$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog",
	"$FileBrowser.filter = \\\"Image files | *.png;*.jpg\\\"",
	"[void]$FileBrowser.ShowDialog()",
	"$FileBrowser.FileName"
	]
	var out = exec_script(ps_script_file)
	print(out)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
