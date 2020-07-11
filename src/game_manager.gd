extends Node

signal food_updated

var selected_unit = null

var _total_food = 0 setget ,get_total_food

func get_total_food():
	return _total_food

func select_unit(selected):
	selected_unit = selected

func target(targeted):
	if selected_unit != null:
		selected_unit.target(targeted)
		print("unit %s targets %s" % [selected_unit, targeted])

func store_food(amount):
	_total_food += amount
	print("food: %d" % _total_food)
	emit_signal("food_updated", _total_food)

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if selected_unit != null:
			selected_unit.move_to(event.position)
