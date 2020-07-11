extends Timer

export var harvest_speed = 5

var harvesting = false
var to_harvest = null

func start_harvesting(resource):
	to_harvest = resource
	self.start()
	resource.connect("harvested", self, "_stop_harvesting")
	harvesting = true
	
	
func stop_harvesting():
	to_harvest = null
	harvesting = false
	self.stop()


func harvest():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		stop_harvesting()
	
	if harvesting == false:
		return
	
	to_harvest.get_gathered(harvest_speed)


func _on_CollectTimer_timeout():
	harvest()
