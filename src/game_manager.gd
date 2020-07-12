extends Node

signal food_updated

var selecting_unit = false
var selected_unit = null

var _total_food = 0 setget ,get_total_food

var profile_picture = preload("ui/profile_picture.gd")

func get_total_food():
	return _total_food


func select_unit(selected):
	if selected_unit != null:
		selected_unit.get_node("AnimatedSprite").stop_drawing_selection()
	selected_unit = selected
	print($GUI)
	print(get_node("GUI/ProfilePicture"))
	profile_picture.display_picture(selected.get_morale())
	#.display_picture(selected.get_morale())


func target(targeted):
	if selected_unit != null:
		selected_unit.target(targeted)
		print("unit %s targets %s" % [selected_unit, targeted])


func store_food(amount):
	_total_food += amount
	emit_signal("food_updated", _total_food)


func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if selected_unit != null:
			print("event pos %s global mouse pos %s" % [event.position, event.global_position])
			print("ordered %s to move to %s" % [selected_unit,event.global_position])
			selected_unit.move_to(event.global_position)
