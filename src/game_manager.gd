extends Node

signal food_updated

var selected_unit = null

var total_food = 0

func _ready():
	pass

func select_unit(selected):
	selected_unit = selected

func target(targeted):
	if selected_unit != null:
		selected_unit.target(targeted)
		print("unit %s targets %s" % [selected_unit, targeted])

func store_food(amount):
	total_food += amount
	print("food: %d" % total_food)
	emit_signal("food_updated", total_food)

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if selected_unit != null:
			selected_unit.move_to(event.position)
