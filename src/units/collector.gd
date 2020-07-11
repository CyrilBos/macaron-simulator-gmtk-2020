extends KinematicBody2D

export var selected = false # TODO: handle this
export var speed = 20.0
export var target_delta = 35.0

enum State { MOVING, HARVESTING, IDLE } # TODO: Finite State Machine?
var _current_state = State.IDLE

var _target_position = null
var _target_node = null

func move_to(position):
	_target_position = position
	_current_state = State.MOVING

func target(targeted):
	if targeted == self:
		return
		
	_target_node = targeted
	_target_position = targeted.get_global_position()
	print("collector %s targets " % self.to_string() + _target_node.to_string())	

func _get_distance_vec_to_target():
	if _target_position == null:
		return 0
	
	return _target_position - self.global_position

func _is_target_in_range():
	if _target_position == null:
		return 0
	
	return _get_distance_vec_to_target().length() < target_delta

func _process(delta):
	if _target_node == null or _current_state == State.IDLE:
		return
		
	if _is_target_in_range():
		if _target_node.get_entity_type() == Entity.Types.RESOURCE and _current_state != State.HARVESTING:
			$CollectTimer.start_harvesting(_target_node)
			_current_state = State.HARVESTING
			
	elif _current_state == State.HARVESTING:
		$CollectTimer.stop_harvesting()
		_current_state == State.MOVING
			

func _physics_process(delta):
	if _target_position == null or _current_state != State.MOVING:
		return
		
	# TODO: calculate target sprite width or handle collision in bush to stop movement?
	if not _is_target_in_range(): 
		move_and_slide(_get_distance_vec_to_target().normalized() * speed)
	else:
		_target_position = null

func _on_KinematicBody_input_event(viewport, event, shape_idx):
	if not selected and Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("collector selected " + self.to_string())
		GameManager.select_unit(self)
		$AnimatedSprite.draw_selection()
