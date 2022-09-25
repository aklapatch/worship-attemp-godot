extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var zoomslider: HSlider = get_node("../HSlider")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# grab the value of the slider and print it here
	self.set_text("%d" % int(zoomslider.value))
	
