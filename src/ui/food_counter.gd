extends RichTextLabel

func update_food_counter(food_value):
	print("updating food value")
	self.set_text("Food: %d" % food_value)



func _on_food_updated(total_food):
	update_food_counter(total_food)
