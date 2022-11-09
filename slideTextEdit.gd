extends TextEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var previewtext = get_node("../../../Preview/Previewtext")
onready var bold_button = get_node("../HFlowContainer/CheckButton")
onready var italic  = get_node("../HFlowContainer/CheckButton2")
onready var justification  = get_node("../HFlowContainer/VBoxContainer2/OptionButton2")

onready var old_just = justification.selected
onready var old_italic = italic.toggle_mode
onready var old_bold_button = bold_button.toggle_mode
onready var old_txt_len = len(self.text)

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(previewtext != null)


# reach out to the preview text and update it when we have changed
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_len = len(self.text)
	if new_len != old_txt_len or old_bold_button != bold_button.toggle_mode or old_italic != italic.toggle_mode or old_just != justification.selected:
		old_bold_button = bold_button.toggle_mode
		old_txt_len = new_len
		old_italic = italic.toggle_mode
		old_just = justification.selected
		
		# add bbcode tags based on bold/italic buttons
		var preview_text = self.text
		if bold_button.toggle_mode:
			preview_text = '[b]' + preview_text + '[/b]'
			
		if italic:
			preview_text = '[i]' + preview_text + '[/i]'
			
		# Set justification
		if justification.selected == 1:
			# Right justification
			preview_text = '[right]' + preview_text + '[/right]'
		elif justification.selected == 2:
			preview_text = '[center]' + preview_text + '[/center]'
			
		previewtext.bbcode_text = preview_text
