extends Node

onready var game_manager = SceneFinder.get_game_manager()
onready var fighting = game_manager.get_node("/GUI/MacrabronHealthControl/HSplitContainer/HealthBar")


func get_entity_type():
	return Entity.Types.ENEMY


func lose_health(dmg):
	fighting.lose_health(dmg)


func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		game_manager.target(self)
	
	
func _on_GiletDetector_detected():
	pass # Replace with function body.
