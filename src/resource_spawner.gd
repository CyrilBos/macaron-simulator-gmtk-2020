extends Timer

export var spawn_freq = 5

const RESOURCE = preload("res://src/objects/MoneyPrinter.tscn")

onready var unit_spawner = get_parent().get_node("UnitSpawner")

func _ready():
	self.start(spawn_freq)
	

func _spawn_resources():
	var viewport = get_viewport()

	var new_resource_count = unit_spawner.get_unit_count() / 2
	print("spawning %s new resources" % new_resource_count)
	for _n in range(new_resource_count):
		var rnd_pos = Vector2(rand_range(50, viewport.size.x - 50), rand_range(50, viewport.size.y - 50))
	
		var new_resource = RESOURCE.instance()
		new_resource.global_translate(rnd_pos)
	
		get_parent().add_child(new_resource)


func _on_ResourceSpawner_timeout():
	_spawn_resources()
