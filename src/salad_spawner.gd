extends Timer

export var spawn_freq = 5

const SALAD = preload("res://src/objects/salad.tscn")


func _ready():
	self.start(spawn_freq)
	

func _spawn_salads():
	var viewport = get_viewport()
		
	for n in range(UnitSpawner.get_unit_count()):
		var rnd_pos = Vector2(rand_range(50, viewport.size.x - 50), rand_range(50, viewport.size.y - 50))
	
		var new_salad = SALAD.instance()
		new_salad.global_translate(rnd_pos)
	
		get_parent().add_child(new_salad)


func _on_SaladSpawner_timeout():
	_spawn_salads()
