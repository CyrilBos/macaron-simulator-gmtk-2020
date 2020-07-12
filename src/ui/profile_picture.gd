extends Sprite

onready var morale_label = $MoraleLabel

const happy_string = "il est content" # TODO: i18n
const unhappy_string = "il est pas très content"
const gilet_string = "MOKRON DÉMISSION"

func display_picture(morale):
	self.set_visible(true)
	var message = happy_string if morale > 50 else gilet_string if morale <=0 else unhappy_string
	morale_label.set_text("Morale: %s" % message)
	morale_label.set_visible(true)
