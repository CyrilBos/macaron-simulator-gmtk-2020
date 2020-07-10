extends AnimatedSprite


var targeted = false


func _input_event(_viewport, event, shape_idx):
	if event is InputEventMouseButton:
		targeted = event.pressed
	
func _on_StaticBody_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		GameManager.target(self)
