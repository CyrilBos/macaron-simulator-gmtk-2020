extends Node

const WORKER = preload("res://src/units/worker.tscn")
const food_threshold_spawn = 40

onready var viewport = get_viewport()

func _ready():
	GameManager.connect("food_updated", self, "_spawn_unit_if_threshold_reached")

func _spawn_unit_if_threshold_reached(total_food):
	
	if total_food >= food_threshold_spawn:
		GameManager.consume_food(food_threshold_spawn)
		var new_worker = WORKER.instance()
	
		var rnd_pos = Vector2(rand_range(0, viewport.size.x), rand_range(0, viewport.size.y))
		new_worker.global_translate(rnd_pos)
	
		GameManager.add_child(new_worker)
