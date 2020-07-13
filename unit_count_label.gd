extends Label


func _ready():
	UnitSpawner.connect("unit_count_updated", self, "_update_unit_counter")
	
	
func _update_unit_counter(worker_count, gilet_count):
	self.set_text("%d worker_count %d gilet_count" % [worker_count, gilet_count])
