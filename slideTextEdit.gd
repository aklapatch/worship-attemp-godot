extends TextEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var previewtext = get_node("../../../Preview/Previewtext")

onready var justify_text = 0
onready var old_txt_len = len(self.text)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(previewtext != null)
	
func set_just_push_text(just_val):
	# Set justification
	justify_text = just_val
	var preview_text = self.text
	if justify_text == 2:
		# Right justification
		preview_text = '[right]' + preview_text + '[/right]'
	elif justify_text == 0:
		preview_text = '[center]' + preview_text + '[/center]'
		
	previewtext.update_text(preview_text)

# reach out to the preview text and update it when we have changed
# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
onready var set_to_zero = false
func _process(delta):
	var new_len = len(self.text)
	if new_len != old_txt_len:
		set_just_push_text(justify_text)
		set_to_zero = false
	elif new_len == 0 and not set_to_zero:
		previewtext.update_text("")
		set_to_zero = true
