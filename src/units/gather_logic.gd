extends Timer

export var harvest_amount = 5
export var harvest_frequency_seconds = 0.75

onready var worker = get_parent().get_parent()

var salad_detector = null setget set_salad_detector

var harvesting = false
var to_harvest = null

signal gather_ticked
signal stopped_gathering


func set_salad_detector(value):
	salad_detector = value


func start_gathering(resource):
	to_harvest = resource
	self.start(harvest_frequency_seconds)
	resource.connect("harvested", self, "stop_gathering")
	harvesting = true

	
func _stop_gathering():
	to_harvest = null
	harvesting = false

	emit_signal("stopped_gathering")


func _switch_salad_or_stop_gathering():
	self.stop()
	
	var next = salad_detector.get_next_detected_salad()
	if next == null:
		_stop_gathering()
	else:
		start_gathering(next)
	

func _gather():
	if to_harvest == null:
		print("c pa b1 de harvest 1 truk null")
		_switch_salad_or_stop_gathering()
	
	if harvesting == false:
		return
	
	to_harvest.get_gathered(harvest_amount)
	GameManager.store_food(harvest_amount)
	emit_signal("gather_ticked", harvest_amount)


func _on_CollectTimer_timeout():
	_gather()


func _on_Worker_target_out_of_reach():
	if not worker.is_moving():
		_stop_gathering()


func _on_Worker_state_changed(new_state):
	if new_state != worker.State.GATHERING:
		_stop_gathering()
