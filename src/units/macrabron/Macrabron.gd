extends KinematicBody2D

enum State { PATROLLING, SEEKING, FIGHTING }

export var macrabron_range = 180
export var speed = 15
onready var game_manager = SceneFinder.get_game_manager()
onready var fighting = game_manager.get_node("GUI/MacrabronHealthControl/HSplitContainer/HealthBar")
onready var _nav_handler = load("res://src/units/navigating.gd").new()

onready var _seek_sound = $SeekSound

func _ready():
	fighting.connect("death", self, "_die")


static func get_entity_type():
	return Entity.Types.ENEMY


var _targeted_gilet = null
var _cur_state = State.PATROLLING

func _process(_delta):
	if _cur_state == State.SEEKING:
		if _nav_handler.target_is_in_range(self.get_global_position(), false, macrabron_range):
			fighting.fight(_targeted_gilet)
	
	if _cur_state == State.FIGHTING:
		if not _nav_handler.target_is_in_range():
			if _targeted_gilet == null:
				_cur_state = State.PATROLLING
			else:
				_target(_targeted_gilet)


func _physics_process(delta):
	if _cur_state == State.PATROLLING:
		pass #TODO: rfsioghgodihjo
	elif _cur_state == State.SEEKING:
		var direction = _nav_handler.follow(self.get_global_position(), false, macrabron_range)
	
		if direction == null or direction == Vector2.ZERO:
			return
		
		var collision = move_and_collide(direction * speed * delta)
	
		if collision:
			# will recalculate path
			_nav_handler.follow(self.get_global_position(), false, macrabron_range, true)


func lose_health(dmg):
	fighting.lose_health(dmg)
	

func is_dead():
	return fighting.is_dead()


func _die():
	queue_free()

func _target(gilet):
	_targeted_gilet = gilet
	_nav_handler.target(gilet)
	_nav_handler.seek(gilet, _seek_sound)
	_cur_state = State.SEEKING

func _on_KinematicBody2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		game_manager.target(self)
	
	
func _on_GiletDetector_detected(body):
	_target(body)
