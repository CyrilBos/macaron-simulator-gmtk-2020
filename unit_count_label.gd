extends Label


func _update_unit_counter(worker_count, gilet_count):
	self.set_text("Farmers: %d GILETS: %d" % [worker_count, gilet_count])


func _on_UnitSpawner_units_counts_updated(workers, gilets):
	_update_unit_counter(workers, gilets)
