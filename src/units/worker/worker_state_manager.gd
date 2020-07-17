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

signal death

onready var _sprite = $AnimatedSprite
onready var morale_bar = $MoraleBar
onready var gatherer = $GatherLabel/GatherTimer
onready var fight_logic = $HealthBar
onready var seek_detector = $GiletArea
onready var resource_detector = $ResourceDetector
onready var _seek_enemy_sound = $GiletArea/GiletSeekSound

var _current_state = States.IDLE

var _gilet setget ,is_gilet

func get_entity_type():
	return Entity.Types.UNIT


func reset_state():
	_switch_state_to(States.IDLE)
	
	if is_gilet():
		seek(seek_detector.next_enemy())
	else:
		target(resource_detector.next_resource())


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


func move_to(pos):
	_movement_target == pos
	_switch_state_to(States.MOVING)
	
# TODO: same as as seek? or seek only for moving targets? And then working should use move_to?
func target(targeted):
	_target_node = targeted
	_switch_state_to(States.SEEKING)


func seek(enemy):
	if enemy == null:
		print("not a poor dude bro")
		return
	
	if enemy != _target_node:
		print("gilet %s seeks %s" % [self, enemy])
		_seek_enemy_sound.play()
	target(enemy)


var _movement_target = null
var _target_node = null
var _nav_handler = Navigator.new()

func _ready():
	_switch_state_to(initial_state)
	morale_bar.set_value(initial_morale)
	
	if initial_morale <= 0:
		GILET_JAUNE()
	
	# TODO: clean up children dependencies "injection" like this
	gatherer.set_resource_detector(resource_detector)
	
	var err = GameManager.connect("unit_selected", self, "_on_new_unit_selected")
	if err:
		print(err)


func _process(_delta):
	if _current_state == States.IDLE:
		_wander()
		return
	# TODO: see above for seek()
	if _current_state == States.SEEKING:
		if _nav_handler.target_is_in_range(self.get_global_position(), _target_node.get_global_position(), _get_target_range()):
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
	_switch_state_to(States.WORKING)


func _fight():
	fight_logic.fight(_target_node)
	_switch_state_to(States.FIGHTING)
	

func _physics_process(_delta):
	if not _current_state in NAVIGATING_STATES:
		return
		
	var target_pos = _movement_target if _current_state == States.MOVING else _target_node.get_global_position()
	
	if target_pos == null:
		print("[BUG] target_pos was null for %s with state %s" % [self, _current_state])
		return
	
	var direction = _nav_handler.follow(self.get_global_position(), target_pos, _get_target_range())
	
	if direction == null:
		_compute_new_state()
		return
	
	var collision = _take_a_step_towards(direction)

	if collision:
		# will recalculate path
		_nav_handler.follow(self.get_global_position(), target_pos, _get_target_range(), true)


func _get_target_range():
	return movement_delta if _current_state == States.MOVING else targetting_range


func _compute_new_state():
	_wander()

	
func _switch_state_to(new_state):
	_current_state = new_state
	emit_signal("state_changed", new_state)
	

func _take_a_step_towards(direction):
	return move_and_slide(direction * speed)


func GILET_JAUNE():
	_gilet = true
	_sprite.play("gilet")
	reset_state()
	emit_signal("gilet_changed", true)


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


func _on_ResourceDetector_resource_detected(resource):
	if _current_state != States.SEEKING and _current_state != States.WORKING and not is_gilet():
		target(resource)

