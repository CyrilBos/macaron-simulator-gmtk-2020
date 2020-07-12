extends KinematicBody2D

enum State { IDLE, MOVING, GATHERING, FIGHTING } # TODO: Finite State Machine?

# export var animation = "default"
export var initial_state = State.IDLE
export var initial_morale = 50

export var speed = 20.0
export var targetting_range = 64.0
export var fighting_range = 128.0
export var movement_delta = 10

onready var _sprite = $AnimatedSprite
onready var morale_bar = $MoraleBar
onready var gather_logic = $GatherLabel/GatherTimer
onready var fight_logic = $HealthBar

var _current_state = State.IDLE

var _gilet setget ,is_gilet

signal state_changed
signal gilet_changed
signal target_out_of_reach

func GILET_JAUNE():
	_gilet = true
	_sprite.play("gilet")
	emit_signal("gilet_changed", true)


func _ready():
	# $AnimatedSprite.play(animation)
	_switch_state(initial_state)
	morale_bar.set_value(initial_morale)
	if initial_morale <= 0:
		GILET_JAUNE()
		
	gather_logic.set_salad_detector($SaladDetector)
	
	GameManager.connect("unit_selected", self, "_on_new_unit_selected")


var selected = false

var _movement_target = null
var _target_node = null

func reset_state():
	_switch_state(State.IDLE)

func _on_new_unit_selected(selected_unit):
	if self != selected_unit:
		_switch_state(State.IDLE)

func is_moving():
	return _current_state == State.MOVING;

func get_entity_type():
	return Entity.Types.UNIT

func is_gilet():
	return _gilet

func lose_health(dmg):
	fight_logic.lose_health(dmg)


func get_morale():
	return morale_bar.get_value()


func move_to(position):
	_target_node = null
	_movement_target = position
	
	_switch_state(State.MOVING)


func target(targeted):
	if targeted == self:
		return
		
	_target_node = targeted
	_movement_target = targeted.get_global_position()
	_switch_state(State.MOVING)
	print("worker %s targets " % self.to_string() + _target_node.to_string())	


func seek(poor_dude):
	print("gilet %s seeks %s" % [self, poor_dude])
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


func _gather():
	gather_logic.gather(_target_node)
	_switch_state(State.GATHERING)


func _fight():
	fight_logic.fight(_target_node)
	_switch_state(State.FIGHTING)


func _process(_delta):
	if _current_state == State.IDLE:
		var global_pos = self.get_global_position()
		var random_vector = Vector2(rand_range(-100, 100), rand_range(-100, 100))
		move_to(global_pos + random_vector)
		
	elif _current_state == State.MOVING:
		if _target_node != null:
			if _is_target_in_range():
				if _target_node.get_entity_type() == Entity.Types.RESOURCE:
					_gather()
				
				elif _target_node.get_entity_type() == Entity.Types.UNIT:
					_fight()
			else:
				emit_signal("target_out_of_reach")


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
		_sprite.draw_selection()


func _on_FoodDetectionArea_resource_detected(resource):
	if _current_state == State.IDLE:
		target(resource)


func _on_DeathSound_finished():
	_switch_state(State.IDLE)


func _on_HealthBar_death():
	queue_free()


func _on_HealthBar_killed():
	_switch_state(State.IDLE)


func _on_GatherTimer_stopped_gathering():
	_switch_state(State.IDLE)
