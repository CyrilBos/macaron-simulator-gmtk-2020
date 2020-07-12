extends Label

func _display_gather_label(food_gathered):
	self.set_text("+ %d føød" % food_gathered)
	$Animation.play("Slidisappear")

func _on_GatherTimer_gather_ticked(food_gathered):
	_display_gather_label(food_gathered)
