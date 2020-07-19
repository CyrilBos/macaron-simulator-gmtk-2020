extends Node

export var starting_resources_count = 1

const MIN_RESOURCE = 3

const RESOURCE = preload("res://src/objects/MoneyPrinter.tscn")

onready var unit_spawner = get_parent().get_node("UnitSpawner")

var resources_count = starting_resources_count


func _ready():
	for _n in range(starting_resources_count):
		_spawn_resources()


func _spawn_resources():
	var viewport = get_viewport()

	if  resources_count <= MIN_RESOURCE:
		var new_resource_count = max(MIN_RESOURCE, unit_spawner.get_unit_count() / 3)
		print("spawning %s new resources" % new_resource_count)
		_spawn_resource(viewport.size)


func _spawn_resource(viewport_size):
	var rnd_pos = Vector2(rand_range(50, viewport_size.x - 50), rand_range(50, viewport_size.y - 50))

	var new_resource = RESOURCE.instance()
	new_resource.global_translate(rnd_pos)

	new_resource.connect("harvested", self, "_spawn_resources")

	get_parent().add_child(new_resource)
