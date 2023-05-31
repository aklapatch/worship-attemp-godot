extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@onready var zoomslider: HSlider = get_node("../HSlider")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_text("%.1f" % zoomslider.value)
	var connect_ret = zoomslider.value_changed.connect(match_slider_val)
	assert(connect_ret == OK, "ERROR: %d connecting signal" % connect_ret)

func match_slider_val(val: float):
	self.set_text("%.1f" % val)
