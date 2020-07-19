extends Label

onready var game_manager = SceneFinder.get_game_manager()


func _ready():
	game_manager.connect("help_key", self, "_toggle_visib")
	
func _toggle_visib():
	self.set_visible(not self.visible)
