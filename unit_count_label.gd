extends Label


func _ready():
	UnitSpawner.connect("unit_count_updated", self, "_update_unit_counter")
	
	
func _update_unit_counter():
	
