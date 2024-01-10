extends Tree


@onready var subvp = get_node("SubViewport")
# Called when the node enters the scene tree for the first time.
func _ready():
	var root = self.create_item()
	subvp.size = Vector2(200, 113)
	root.set_icon(0, subvp.get_texture())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
