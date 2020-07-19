extends KinematicBody2D

enum State { PATROLLING, SEEKING, FIGHTING }

export var macrabron_range = 180
export var speed = 60
onready var game_manager = SceneFinder.get_game_manager()
onready var fighting = game_manager.get_node("GUI/MacrabronHealthControl/HSplitContainer/HealthBar")
onready var _nav_handler = load("res://src/units/navigating.gd").new()

onready var _seek_sound = $SeekSound

func _ready():
	fighting.connect("death", self, "_die")
	_switch_patrol_target()


static func get_entity_type():
	return Entity.Types.ENEMY

const LEFT_PATROL_TARGET = Vector2(100, 400)
const RIGHT_PATROL_TARGET = Vector2(1180, 400)

var _targeted_gilet = null
var _cur_state = State.PATROLLING
var _patrol_target = RIGHT_PATROL_TARGET

func _process(_delta):
	var pos = self.get_global_position()
	if _cur_state == State.PATROLLING:
		if _nav_handler.target_is_in_range(pos, false, 16):
			_switch_patrol_target()
	
	elif _cur_state == State.SEEKING:
		if _nav_handler.target_is_in_range(self.get_global_position(), false, macrabron_range):
			fighting.fight(_targeted_gilet)
	
	elif _cur_state == State.FIGHTING:
		if not _nav_handler.target_is_in_range():
			if _targeted_gilet == null:
				_cur_state = State.PATROLLING
			else:
				_target(_targeted_gilet)


func _physics_process(_delta):
	var direction = null
	if _cur_state == State.PATROLLING:
		direction = _nav_handler.get_direction(self.get_global_position(), _patrol_target)
	elif _cur_state == State.SEEKING:
		direction = _nav_handler.follow(self.get_global_position(), false, macrabron_range)
	
	if direction == null or direction == Vector2.ZERO:
		return
	
	var collision = move_and_slide(direction * speed)


func lose_health(dmg):
	fighting.lose_health(dmg)
	

func is_dead():
	return fighting.is_dead()


func _switch_patrol_target():
	if _patrol_target == LEFT_PATROL_TARGET:
		_patrol_to(RIGHT_PATROL_TARGET)
	else:
		_patrol_to(LEFT_PATROL_TARGET)


func _die():
	queue_free()
	
func _patrol_to(pos):
	_targeted_gilet = null
	_patrol_target = pos
	_nav_handler.move_to(pos)
	_cur_state = State.PATROLLING

func _target(gilet):
	if _targeted_gilet != gilet:
		_seek_sound.play()
		
	_targeted_gilet = gilet
	_nav_handler.target(gilet)
	_nav_handler.seek(gilet, _seek_sound)
	_cur_state = State.SEEKING

func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		game_manager.target(self)
	
	
func _on_GiletDetector_detected(body):
	_target(body)
