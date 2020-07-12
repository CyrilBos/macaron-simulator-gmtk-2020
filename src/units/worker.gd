extends KinematicBody2D

export var animation = "default"
export var speed = 20.0
export var targetting_range = 64.0
export var movement_delta = 10

onready var morale_bar = $MoraleBar
onready var gather_logic = $GatherLabel/GatherTimer

enum State { MOVING, GATHERING, IDLE, GILET } # TODO: Finite State Machine?
var _current_state = State.IDLE

signal state_changed

func GILET_JAUNE():
	_switch_state(State.GILET)
	$AnimatedSprite.play("gilet")


func _ready():
	$AnimatedSprite.play(animation)
	_switch_state(State.IDLE)



var selected = false

var _movement_target = null
var _target_node = null

func get_entity_type():
	return Entity.Types.UNIT


func is_idle():
	return _current_state == State.IDLE
	

func is_working():
	return _current_state == State.GATHERING

func get_morale():
	morale_bar.get_value()


func move_to(position):
	_target_node = null
	_movement_target = position
	
	if _current_state == State.GATHERING:
		print("%s moving so stop harvesting" % self)
		gather_logic.stop_gathering()
	
	_switch_state(State.MOVING)


func target(targeted):
	if targeted == self:
		return
		
	_target_node = targeted
	_movement_target = targeted.get_global_position()
	_switch_state(State.MOVING)
	print("worker %s targets " % self.to_string() + _target_node.to_string())	


func seek(poor_dude):
	target(poor_dude)

func _switch_state(new_state):
	_current_state = new_state	
	emit_signal("state_changed", new_state)

	
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
		var global_pos = self.get_global_position()
		var random_vector = Vector2(rand_range(-100, 100), rand_range(-100, 100))
		move_to(global_pos + random_vector)
		
	elif _current_state == State.MOVING:
		if _target_node != null:
			if _is_target_in_range():
				if _target_node != null and _target_node.get_entity_type() == Entity.Types.RESOURCE and _current_state != State.GATHERING:
					gather_logic.start_gathering(_target_node)
					_switch_state(State.GATHERING)


func _physics_process(_delta):
	if _movement_target == null or _current_state != State.MOVING:
		return
	
	# TODO: calculate target sprite width or handle collision in bush to stop movement?
	if not _is_movement_target_reached(): 
		var _toto = move_and_slide(_get_distance_vec_to(_movement_target).normalized() * speed)
	else: # reached target
		_movement_target = null
		_switch_state(State.IDLE)


func _on_KinematicBody_input_event(_viewport, _event, _shape_idx):
	if not selected and Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("collector selected " + self.to_string())
		GameManager.select_unit(self)
		$AnimatedSprite.draw_selection()


func _on_FoodDetectionArea_resource_detected(resource):
	if _current_state == State.IDLE:
		target(resource) #TODO: BUG NO RETARGET NEW FOOD WHEN DONE HARVESTING


func _on_GatherTimer_stopped_gathering():
	_switch_state(State.IDLE)
