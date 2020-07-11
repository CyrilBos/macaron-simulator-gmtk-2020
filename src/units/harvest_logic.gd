extends Timer

export var harvest_amount = 5
export var harvest_frequency_seconds = 0.75

var harvesting = false
var to_harvest = null

signal gather_ticked

func start_gathering(resource):
	to_harvest = resource
	self.start(harvest_frequency_seconds)
	resource.connect("harvested", self, "stop_gathering")
	harvesting = true
	
	
func stop_gathering():
	to_harvest = null
	harvesting = false
	self.stop()


func harvest():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		stop_gathering()
	
	if harvesting == false:
		return
	
	to_harvest.get_gathered(harvest_amount)
	GameManager.store_food(harvest_amount)
	emit_signal("gather_ticked", harvest_amount)
	


func _on_CollectTimer_timeout():
	harvest()
