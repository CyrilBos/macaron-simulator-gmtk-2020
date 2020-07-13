extends Node

export var _unit_count = 3 setget, get_unit_count

signal unit_count_updated

const WORKER = preload("res://src/units/worker.tscn")
const food_threshold_spawn = 40

onready var viewport = get_viewport()

func _ready():
	GameManager.connect("food_updated", self, "_spawn_unit_if_threshold_reached")


func get_unit_count():
	return _unit_count


func _reduce_unit_count():
	_unit_count -= 1
	emit_signal("unit_count_updated", _unit_count)

func _spawn_unit_if_threshold_reached(total_food):
	
	if total_food >= food_threshold_spawn:
		GameManager.consume_food(food_threshold_spawn)
		var new_worker = WORKER.instance()
	
		var rnd_pos = Vector2(rand_range(0, viewport.size.x), rand_range(0, viewport.size.y))
		new_worker.global_translate(rnd_pos)
		
		new_worker.connect("death", self, "_reduce_unit_count")
		
		GameManager.add_child(new_worker)
		
		_unit_count += 1
