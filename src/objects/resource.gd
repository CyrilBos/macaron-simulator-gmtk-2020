extends StaticBody2D

const NaturalResource = preload("natural_resource.gd")

export var start_amount = 25

var targeted = false

var resource = NaturalResource.new(start_amount)

signal harvested

onready var sprite = $AnimatedSprite


func get_entity_type():
	return Entity.Types.RESOURCE;


func get_gathered(harvest_speed):
	resource.reduce_amount(harvest_speed)
	sprite.play("gathered")
	if resource.is_gathered():
		print("%s was harvested" % self)
		emit_signal("harvested")
		queue_free()


func reset_animation():
	sprite.play("default")


func _on_StaticBody_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		GameManager.target(self)
