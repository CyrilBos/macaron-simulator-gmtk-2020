extends Label

onready var game_manager = SceneFinder.get_game_manager()


func _ready():
	var err = game_manager.connect("food_updated", self, "_update_food_counter")
	if err:
		print(err)

func _update_food_counter(total_food):
	self.set_text("Food: %d" % total_food)
