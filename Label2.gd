extends Label

func _on_h_slider_value_changed(value):
	self.set_text("%.1f" % value)
