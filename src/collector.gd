extends KinematicBody2D

const Collector = preload("collector.gd")

export var selected = false # TODO: handle this
export var speed = 10.0
export var target_delta = 50.0

var target = null

var harvesting = false

var collector = Collector.new()

func target(targeted):
	target = targeted
	print("collector %s targets " % self.to_string() + target.to_string())	

func _get_distance_vec_to_target():
	return target.get_global_position() - self.global_position

func _is_target_in_range():
	return _get_distance_vec_to_target().length() < target_delta

func _start_harvesting(resource):
		harvesting = true
		resource.connect("harvested", self, "_stop_harvesting")
		
func _stop_harvesting():
	harvesting = false

func _process(delta):
	if target == null:
		return
		
	if _is_target_in_range():
		if target.get_entity_type() == Entity.Types.RESOURCE:
			if not harvesting:
				print("start harvesting")
				_start_harvesting(target)
			print("harvest")
			collector.harvest(target) # TODO: implement CD with Timer
			

func _physics_process(delta):
	if target == null:
		return
		
	# TODO: calculate target sprite width or handle collision in bush to stop movement?
	if not _is_target_in_range(): 
	# print("dir = %s - %s = %s" % [target.get_global_position(), self.global_position, direction.normalized()])
		move_and_slide(_get_distance_vec_to_target().normalized() * speed)
	else:
		target = null

func _on_KinematicBody_input_event(viewport, event, shape_idx):
	if not selected and Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("collector selected " + self.to_string())
		GameManager.select_unit(self)
