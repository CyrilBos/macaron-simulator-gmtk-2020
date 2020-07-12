extends Timer

export var harvest_amount = 5
export var harvest_frequency_seconds = 0.5

onready var worker = get_parent().get_parent()

var salad_detector = null setget set_salad_detector

var gathering = false
var to_harvest = null

signal gather_ticked


func set_salad_detector(value):
	salad_detector = value


func gather(resource):
	if to_harvest != resource:
		to_harvest = resource
		self.start(harvest_frequency_seconds)
		resource.connect("harvested", self, "_switch_salad_or_stop_gathering")
		
	gathering = true

	
func _stop_gathering():
	to_harvest = null
	gathering = false
	self.stop()


func _switch_salad_or_stop_gathering():
	self.stop()
	
	var next = salad_detector.get_next_detected_salad()
	if next == null:
		_stop_gathering()
		worker.reset_state()
	else:
		print("%s targets next salad %s" % [self, next])
		worker.target(next)
	

func _gather():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		_switch_salad_or_stop_gathering()
	
	if gathering == false:
		return
	
	to_harvest.get_gathered(harvest_amount)
	GameManager.store_food(harvest_amount)
	emit_signal("gather_ticked", harvest_amount)


func _on_CollectTimer_timeout():
	_gather()


func _on_Worker_target_out_of_reach():
	if gathering:
		_stop_gathering()


func _on_Worker_state_changed(new_state):
	if gathering and new_state != worker.State.GATHERING:
		_stop_gathering()
