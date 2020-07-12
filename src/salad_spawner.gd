extends Timer

export var spawn_freq = 5

const SALAD = preload("res://src/objects/salad.tscn")

func _ready():
	self.start(spawn_freq)

func _spawn_salad():
	var viewport = get_viewport()
	
	var rnd_pos = Vector2(rand_range(0, viewport.size.x), rand_range(0, viewport.size.y))
	
	var new_salad = SALAD.instance()
	new_salad.global_translate(rnd_pos)
	
	get_parent().add_child(new_salad)


func _on_SaladSpawner_timeout():
	_spawn_salad()
