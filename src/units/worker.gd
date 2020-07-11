extends KinematicBody2D

export var selected = false # TODO: handle this
export var speed = 20.0
export var targetting_range = 35.0
export var movement_delta = 5

enum State { MOVING, HARVESTING, IDLE } # TODO: Finite State Machine?
var _current_state = State.IDLE

var _movement_target = null
var _target_node = null

func move_to(position):
	_target_node = null
	_movement_target = position
	
	if _current_state == State.HARVESTING:
		print("%s moving so stop harvesting" % self)
		$GatherTimer.stop_harvesting()
	
	_current_state = State.MOVING


func target(targeted):
	if targeted == self:
		return
		
	_target_node = targeted
	_movement_target = targeted.get_global_position()
	print("worker %s targets " % self.to_string() + _target_node.to_string())	


func _get_distance_vec_to(position):
	return position - self.global_position


func _get_distance_to(position):	
	if position == null:
		return 0
	
	return _get_distance_vec_to(position).length() 


func _is_movement_target_reached():	
	return _get_distance_to(_movement_target) < movement_delta


func _is_target_in_range():	
	return _get_distance_to(_target_node.get_global_position()) < targetting_range


func _process(_delta):
	if _current_state == State.IDLE:
		return
		
	if _current_state == State.MOVING:
		if _target_node != null:
			if _is_target_in_range():
				if _target_node != null and _target_node.get_entity_type() == Entity.Types.RESOURCE and _current_state != State.HARVESTING:
					$GatherTimer.start_harvesting(_target_node)
					_current_state = State.HARVESTING


func _physics_process(_delta):
	if _movement_target == null or _current_state != State.MOVING:
		return
	
	# TODO: calculate target sprite width or handle collision in bush to stop movement?
	if self == GameManager.selected_unit and not _is_movement_target_reached(): 
		var _toto = move_and_slide(_get_distance_vec_to(_movement_target).normalized() * speed)
	else:
		_movement_target = null


func _on_KinematicBody_input_event(_viewport, _event, _shape_idx):
	if not selected and Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("collector selected " + self.to_string())
		GameManager.select_unit(self)
		$AnimatedSprite.draw_selection()
