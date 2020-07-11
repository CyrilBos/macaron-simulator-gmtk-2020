extends AnimatedSprite

const NaturalResource = preload("natural_resource.gd")

export var start_amount = 50

var targeted = false

var resource = NaturalResource.new(start_amount)

signal harvested

func get_gathered(harvest_speed):
		resource.reduce_amount(harvest_speed)
		if resource.is_gathered():
			print("harvested")
			emit_signal("harvested")
			queue_free()

func get_entity_type():
	return Entity.Types.RESOURCE;
	
func _on_StaticBody_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_LEFT):
		GameManager.target(self)
