extends Timer

export var harvest_amount = 5
export var harvest_frequency_seconds = 0.5

onready var worker = get_parent().get_parent()

var resource_detector = null setget set_resource_detector

var working = false
var to_harvest = null

signal gather_ticked


func set_resource_detector(value):
	resource_detector = value

# TODO: extract this in another script, and use working as just a work_frequency timer to callback gathering
func gather(resource):
	if to_harvest != resource:
		to_harvest = resource
		self.start(harvest_frequency_seconds)
		resource.connect("harvested", self, "_switch_resource_or_stop_working")
		
	working = true

	
func _stop_working():
	if to_harvest != null:
		to_harvest.reset_animation()
		to_harvest.disconnect("harvested", self, "_switch_resource_or_stop_working")
	to_harvest = null
	working = false
	self.stop()


func _switch_resource_or_stop_working():
	self.stop()
	
	var next = resource_detector.next_resource()
	if next == null:
		_stop_working()
		worker.reset_state()
	else:
		print("%s targets next resource %s" % [self, next])
		worker.target(next)


func _gather():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		_switch_resource_or_stop_working()
	
	if working == false:
		return
	
	to_harvest.get_gathered(harvest_amount)
	GameManager.store_food(harvest_amount)
	emit_signal("gather_ticked", harvest_amount)


func _on_CollectTimer_timeout():
	_gather()


func _on_Worker_target_out_of_reach():
	if working:
		_stop_working()


func _on_Worker_state_changed(new_state):
	if working and new_state != worker.States.GATHERING:
		_stop_working()
