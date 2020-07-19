# TODO: build master Godot for new Nav API with NavigationServer2D
extends Node


func compute_path(_start, end):
	return [end] # TODO: use new Nav API with unstable Godot or replace make money printers spawn at static places


func get_random_position_inside_viewport(border_size):
	var viewport = get_viewport()
	return Vector2(rand_range(border_size, viewport.size.x - border_size),
		rand_range(border_size, viewport.size.y - border_size))
