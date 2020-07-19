extends Node

export var starting_resources_count = 3

const MIN_RESOURCE = 3

const RESOURCE = preload("res://src/objects/MoneyPrinter.tscn")

onready var game_manager = SceneFinder.get_game_manager()
onready var unit_spawner = game_manager.get_node("UnitSpawner")
onready var objects_root = game_manager.get_node("Background")

var resources_count = starting_resources_count


func _ready():
	var viewport = get_viewport()

	for _n in range(starting_resources_count):
		_spawn_resource(viewport.size)


func _spawn_resources():
	var viewport = get_viewport()

	if  resources_count <= MIN_RESOURCE:
		var new_resource_count = max(MIN_RESOURCE, unit_spawner.get_unit_count() / 3)
		print("spawning %s new resources" % new_resource_count)
		for _n in range(new_resource_count):
			_spawn_resource(viewport.size)


func _spawn_resource(viewport_size):
	var rnd_pos = Vector2(rand_range(200, viewport_size.x - 200), rand_range(200, viewport_size.y - 200))

	var new_resource = RESOURCE.instance()
	new_resource.global_translate(rnd_pos)

	new_resource.connect("harvested", self, "_respawn_resources")

	objects_root.call_deferred("add_child", new_resource)

func _respawn_resources():
	resources_count -= 1
	if resources_count < MIN_RESOURCE:
		_spawn_resources()
