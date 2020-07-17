extends Node

var _worker_count = 2 setget, get_worker_count
var _gilet_count = 1 setget, get_gilet_count

signal units_counts_updated

const WORKER = preload("res://src/units/worker/worker.tscn")
const food_threshold_spawn = 40

onready var viewport = get_viewport()


func _ready():
	GameManager.connect("food_updated", self, "_spawn_unit_if_threshold_reached")


func get_worker_count():
	return _worker_count


func get_gilet_count():
	return _gilet_count


func get_unit_count():
	return _worker_count + _gilet_count


func register_new_worker(worker):
	_worker_count += 1
	worker.connect("death", self, "_reduce_unit_count")


func _reduce_unit_count(unit):
	if unit.is_gilet():
		_gilet_count -= 1
	else: 
		_worker_count -= 1
		
	emit_signal("units_counts_updated", _worker_count, _gilet_count)


func _spawn_unit_if_threshold_reached(total_food):
	if total_food >= food_threshold_spawn:
		GameManager.consume_food(food_threshold_spawn)
		var new_worker = WORKER.instance()
	
		var rnd_pos = Vector2(rand_range(50, viewport.size.x - 50), rand_range(50 , viewport.size.y - 50))
		new_worker.global_translate(rnd_pos)
		
		GameManager.add_child(new_worker)
		
		register_new_worker(new_worker)
		
