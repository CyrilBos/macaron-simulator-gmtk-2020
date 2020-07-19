extends Timer

export var harvest_amount = 5
export var harvest_frequency_seconds = 0.5

onready var worker = get_parent().get_parent()

var resource_detector = null setget set_resource_detector

var to_harvest = null

signal gather_ticked


onready var game_manager = SceneFinder.get_game_manager()


func set_resource_detector(value):
	resource_detector = value

	
# TODO: extract this in another script, and use working as just a work_frequency timer to callback gathering
# and do same for fighting? Or too much abstraction?
func gather(resource):
	if to_harvest != resource:
		to_harvest = resource
		self.start(harvest_frequency_seconds)
		resource.connect("harvested", self, "_switch_resource_or_stop_working")

	
func _stop_working():
	if to_harvest != null:
		to_harvest.reset_animation()
		to_harvest.disconnect("harvested", self, "_switch_resource_or_stop_working")
	to_harvest = null
	self.stop()


func _switch_resource_or_stop_working():
	self.stop()
	
	var next = resource_detector.pop_next_detection()
	if next == null:
		print ("no more resources in area, resume wandering")
		_stop_working()
		worker._compute_new_state()
	else:
		print("%s targets next resource %s" % [self, next])
		worker.target(next)


func _gather():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		_switch_resource_or_stop_working()
	else:
		to_harvest.get_gathered(harvest_amount)
		game_manager.store_food(harvest_amount)
		emit_signal("gather_ticked", harvest_amount)


func _on_CollectTimer_timeout():
	_gather()


func _on_Worker_state_changed(new_state):
	if new_state != worker.States.WORKING:
		_stop_working()
