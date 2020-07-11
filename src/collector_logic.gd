extends Object

var harvest_speed = 5
	
func harvest(resource):
	resource.get_gathered(harvest_speed)
