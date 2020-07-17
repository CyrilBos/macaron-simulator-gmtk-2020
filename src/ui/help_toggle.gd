extends Label

func _ready():
	GameManager.connect("help_key", self, "_toggle_visib")
	
func _toggle_visib():
	self.set_visible(not self.visible)
