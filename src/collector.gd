extends KinematicBody2D

export var selected = false # TODO: handle this
export var speed = 10.0
export var target_delta = 10.0

var target = null

func target(targeted):
	target = targeted
	print("collector %s targets " % self.to_string() + target.to_string())	

func _physics_process(delta):
	if target != null:
		var difference = target.get_global_position() - self.global_position
		if difference.length() > target_delta:
		# print("dir = %s - %s = %s" % [target.get_global_position(), self.global_position, direction.normalized()])
			move_and_slide(difference.normalized() * speed)
		else:
			target = null


func _on_KinematicBody_input_event(viewport, event, shape_idx):
	if not selected and Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("collector selected " + self.to_string())
		GameManager.select_unit(self)
