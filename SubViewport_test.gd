extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var _delta = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_delta = delta
	pass
	

func _on_sub_viewport_container_resized():

	pass # Replace with function body.
