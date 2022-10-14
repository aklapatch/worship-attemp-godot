extends Button

# yoinked from https://www.reddit.com/r/godot/comments/pc45q4/hacky_way_to_get_a_native_file_dialog_on_windows/
# Give it an Array of valid PS commands
func exec_script(ps_script : Array) -> int:
	
	var ps_concat = "& { "
	for line in ps_script:
		ps_concat += line + '\n'
	ps_concat += "}"

	var output = []
	print(ps_concat)
	return OS.execute("powershell.exe", ["-Command", ps_concat], true, output)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_button_pressed")
	self.add_user_signal("added_img")

func _button_pressed():
	#fd.popup_centered_minsize(Vector2(100,100))
	var ps_script_folder = [
	"Add-Type -AssemblyName System.Windows.Forms",
	"$FolderDialog = New-Object -Typename System.Windows.Forms.FolderBrowserDialog",
	"[void]$FolderDialog.ShowDialog()",
	"$FolderDialog.SelectedPath"
	]
	var dst = ProjectSettings.globalize_path("user://images/")
	var ps_script_file = [
	"Add-Type -AssemblyName System.Windows.Forms",
	"$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog",
	"$FileBrowser.filter = \\\"Image files | *.png;*.jpg\\\"",
	"[void]$FileBrowser.ShowDialog()",
	"cp $FileBrowser.FileName " + dst
	]
	var out = exec_script(ps_script_file)
	if out != 0:
		push_warning("Failed to import image")
	# move the file to user:// images
	# TODO: have powershell copy the file. This method doesn't work for somem reason.
	emit_signal("added_img")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
