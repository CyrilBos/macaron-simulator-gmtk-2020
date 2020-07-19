extends Node


func get_game_manager():
	return get_tree().get_root().get_node("GameManager")

	
func get_navigation_manager():
	return get_game_manager().get_node("NavigationManager")
