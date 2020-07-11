extends Node

enum EntityTypes { RESOURCE, ENEMY }

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

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_LEFT):
		if selected_unit != null:
			selected_unit.move_to(event.position)
