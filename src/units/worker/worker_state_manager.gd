extends KinematicBody2D

enum States { IDLE, MOVING, SEEKING, WORKING, FIGHTING }

const NAVIGATING_STATES = [States.MOVING, States.SEEKING]
const ACTIVITY_STATES = [States.WORKING, States.FIGHTING]

const RANDOM_POS_SEARCH_DISTANCE = 150

# export var animation = "default"
export var initial_state = States.IDLE
export var initial_morale = 50

export var speed = 20.0
export var targetting_range = 64.0
export var movement_delta = 16

signal state_changed
signal gilet_changed
signal target_out_of_reach

signal death

onready var _sprite = $AnimatedSprite
onready var _navigator = $Navigation2D
onready var morale_bar = $MoraleBar
onready var gatherer = $GatherLabel/GatherTimer
onready var fight_logic = $HealthBar
onready var seek_detector = $GiletArea
onready var resource_detector = $ResourceDetector

var _current_state = States.IDLE

var _gilet setget ,is_gilet

func get_entity_type():
	return Entity.Types.UNIT


func reset_state():
	_switch_state_to(States.IDLE)
	
	if is_gilet():
		seek(seek_detector.next_enemy())
	else:
		target(resource_detector.next_salad())


func _on_new_unit_selected(selected_unit):
	if self != selected_unit and is_gilet():
		seek(seek_detector.next_enemy())


func is_moving():
	return _current_state == States.MOVING;


func is_gilet():
	return _gilet


func lose_health(dmg):
	fight_logic.lose_health(dmg)


func get_morale():
	return morale_bar.get_value()


func move_to(position):
	_switch_state_to(States.MOVING)
	

func target(targeted):
	_target_node = targeted
	_switch_state_to(States.SEEKING)


func seek(enemy):
	if enemy == null:
		print("not a poor dude bro")
		return
	
	if enemy != _target_node:
		print("gilet %s seeks %s" % [self, enemy])
		$GiletArea/GiletSeekSound.play()
	target(enemy)


var _movement_target = null
var _target_node = null


func _ready():
	_switch_state_to(initial_state)
	morale_bar.set_value(initial_morale)
	
	if initial_morale <= 0:
		_GILET_JAUNE()
	
	# TODO: clean up children dependencies "injection" like this
	gatherer.set_resource_detector(resource_detector)
	
	GameManager.connect("unit_selected", self, "_on_new_unit_selected")


func _process(_delta):
	if _current_state == States.IDLE:
		_wander()
		return
	
	if _current_state == States.SEEKING:
		if _navigator._is_target_node_reachable(_target_node):
			_compute_new_state()
			
		if _target_node.get_entity_type() == Entity.Types.RESOURCE:
				_gather()
			
		elif _target_node.get_entity_type() == Entity.Types.UNIT:
				_fight()


func _wander():
	# TODO: target resource / enemy automatically
	var global_pos = self.get_global_position()
	var random_vector = Vector2(rand_range(-RANDOM_POS_SEARCH_DISTANCE, RANDOM_POS_SEARCH_DISTANCE),
	 rand_range(-RANDOM_POS_SEARCH_DISTANCE, RANDOM_POS_SEARCH_DISTANCE))
	move_to(global_pos + random_vector)


func _gather():
	gatherer.gather(_target_node)
	_switch_state_to(States.GATHERING)


func _fight():
	fight_logic.fight(_target_node)
	_switch_state_to(States.FIGHTING)
	

func _physics_process(delta):
	if not _current_state in NAVIGATING_STATES:
		return
		
	var target_pos = _movement_target if _current_state == States.MOVING else _target_node.get_global_position()
	
	var direction = _navigator.follow(target_pos, _get_target_range())
		
	if direction == Vector2.ZERO:
		_compute_new_state()
	
	var collision = _take_a_step_towards(direction)

	if collision:
		# will recalculate path
		_navigator.follow(target_pos, _get_target_range(), true)

func _get_target_range():
	return movement_delta if _current_state == States.MOVING else targetting_range

func _compute_new_state():
	_compute_new_state_from_movement() if _current_state in NAVIGATING_STATES else _compute_new_state_from_activity()


func _compute_new_state_from_movement():
	if _current_state == States.SEEKING:
		_fight()
	elif _current_state == States.MOVING:
		_wander()


func _compute_new_state_from_activity():
	if _current_state == States.FIGHTING:
		_wander()


func _GILET_JAUNE():
	_gilet = true
	_sprite.play("gilet")
	reset_state()
	emit_signal("gilet_changed", true)

	
func _switch_state_to(new_state):
	_current_state = new_state
	emit_signal("state_changed", new_state)
	

func _take_a_step_towards(direction):
	move_and_slide(position * speed)


func _on_KinematicBody_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		GameManager.select_unit(self)
		_sprite.draw_selection()


func _on_DeathSound_finished():
	_switch_state_to(States.IDLE)


func _on_HealthBar_death():
	emit_signal("death")
	queue_free()


func _on_HealthBar_killed():
	reset_state()


func _on_GiletArea_new_enemy(enemy):
	if is_gilet():
		if _target_node == null: # TODO: is macrabron
			seek(enemy)


func _on_SaladDetector_resource_detected(salad):
	if _current_state != States.WORKING and not is_gilet():
		target(salad)
