extends Node


func get_entity_type():
	return Entity.Types.ENEMY


func _on_GiletDetector_detected():
	pass # Replace with function body.


func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		GameManager.target(self)
	
