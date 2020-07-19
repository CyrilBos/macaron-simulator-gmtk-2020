extends KinematicBody2D

enum States { IDLE, MOVING, SEEKING, WORKING, FIGHTING }

const NAVIGATING_STATES = [States.MOVING, States.SEEKING]
const ACTIVITY_STATES = [States.WORKING, States.FIGHTING]

# export var animation = "default"
export var initial_state = States.IDLE
export var initial_morale = 50

export var speed = 20.0
export var printer_targetting_range = 90
export var macrabron_targetting_range = 150
export var movement_delta = 16


var _gilet setget ,is_gilet


var _target_node = null

static func get_entity_type():
	return Entity.Types.UNIT


func is_gilet():
	return _gilet


func is_moving():
	return _current_state == States.MOVING;
	

func reset_state():
	_compute_new_state()
	

func lose_health(dmg):
	fighting.lose_health(dmg)


func is_dead():
	return fighting.is_dead()

func get_morale():
	return morale_bar.get_value()


func handle_manual_targeting(targeted):
	if targeted.get_entity_type() == Entity.Types.RESOURCE and not is_gilet():
		target(targeted)
	elif targeted.get_entity_type() == Entity.Types.ENEMY and is_gilet():
		target(targeted)


func move_to(pos):
	_nav_handler.move_to(pos)
	_switch_state_to(States.MOVING)
	

func target(targeted):
	_target_node = targeted
	_nav_handler.target(targeted)
	_nav_handler.seek(targeted, _seek_enemy_sound)
	_switch_state_to(States.SEEKING)


func GILET_JAUNE(): #TODO: private and signal in morale?
	_gilet = true
	_sprite.play("gilet")
	reset_state()
	emit_signal("gilet_changed", true)


onready var game_manager = SceneFinder.get_game_manager()
onready var _nav_handler = load("res://src/units/navigating.gd").new()

onready var _sprite = $AnimatedSprite
onready var morale_bar = $MoraleBar
onready var gatherer = $GatherLabel/GatherTimer
onready var fighting = $HealthBar
onready var resource_detector = $ResourceDetector
onready var _seek_enemy_sound = $MacrabronDetector/GiletSeekSound


func _ready():
	_switch_state_to(initial_state)
	morale_bar.set_value(initial_morale)
	
	if initial_morale <= 0:
		GILET_JAUNE()
	
	# TODO: clean up children dependencies "injection" like this
	gatherer.set_resource_detector(resource_detector)

		


var _current_state = States.IDLE

func _process(_delta):
	if _current_state == States.IDLE:
		_wander()
		return
	if _current_state == States.SEEKING:
		if _nav_handler.target_is_in_range(self.get_global_position(), 
			false, 
			_get_target_range()
		):
			var target_type = _nav_handler.get_target().get_entity_type()
			if  target_type == Entity.Types.RESOURCE:
				_gather()
				
			elif target_type == Entity.Types.ENEMY:
				_fight()


func _physics_process(_delta):
	if not _current_state in NAVIGATING_STATES:
		return
	
	
	var target_pos = _nav_handler.get_target_pos(_is_moving())
	
	if target_pos == null:
		print("[BUG] target_pos was null for %s with state %s" % [self, _current_state])
		return
	
	var direction = _nav_handler.follow(self.get_global_position(), _is_moving(), _get_target_range())
	
	if direction == null or direction == Vector2.ZERO:
		_compute_new_state()
		return
	
	var collision = _take_a_step_towards(direction)

	if collision:
		# will recalculate path
		_nav_handler.follow(self.get_global_position(), _is_moving(), _get_target_range(), true)


func _is_moving():
	return _current_state == States.MOVING


func _wander():
	move_to(_nav_handler.get_wandering_pos())


func _gather():
	gatherer.gather(_target_node)
	_switch_state_to(States.WORKING)


func _fight():
	fighting.fight(_target_node)
	_switch_state_to(States.FIGHTING)
	

func _compute_new_state():
	_wander()

	
func _switch_state_to(new_state):
	_current_state = new_state
	emit_signal("state_changed", new_state)


func _take_a_step_towards(direction):
	return move_and_slide(direction * speed)
	

func _get_target_range():
	if _current_state == States.MOVING:
		return movement_delta
	elif _current_state == States.SEEKING:
		var target_type = _target_node.get_entity_type()
		if target_type == Entity.Types.RESOURCE:
			return printer_targetting_range
		else:
			return macrabron_targetting_range


signal state_changed
signal gilet_changed

signal death


func _on_KinematicBody2D_input_event(_viewport, _event, _shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		game_manager.select_unit(self)
		_sprite.draw_selection()
		

func _on_DeathSound_finished():
	_switch_state_to(States.IDLE)


func _on_HealthBar_death():
	emit_signal("death")
	queue_free()


func _on_HealthBar_killed():
	reset_state()


func _on_ResourceDetector_detected(resource):
	if _current_state != States.WORKING and not is_gilet():
		target(resource)


func _on_MacrabronDetector_detected(macrabron):
	if _current_state == States.SEEKING and not is_gilet():
		_nav_handler.seek(macrabron)
