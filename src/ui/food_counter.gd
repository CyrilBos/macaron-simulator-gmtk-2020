extends RichTextLabel

func _ready():
	var err = GameManager.connect("food_updated", self, "_update_food_counter")
	if err:
		print(err)

func _update_food_counter(total_food):
	print("updating food value")
	self.set_text("Food: %d" % total_food)
