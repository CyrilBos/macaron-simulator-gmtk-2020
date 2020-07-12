extends TextureRect

onready var morale_label = $MoraleLabel

const happy_string = "il est content" # TODO: i18n
const unhappy_string = "il est pas très content"
const gilet_string = "il a le moral dans les chaussettes. MOKRON DÉMISSION!"

func _ready():
	GameManager.connect("unit_selected", self, "display_picture")

func display_picture(selected_unit):
	self.set_visible(true)
	var morale = selected_unit.get_morale()
	var message = happy_string if morale > 50 else gilet_string if morale <= 0 else unhappy_string
	morale_label.set_text("Morale: %s" % message)
	morale_label.set_visible(true)
