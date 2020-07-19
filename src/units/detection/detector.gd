extends Area2D

# ABSTRACT
class_name Detector


var detections = []


func _body_is_detected(_body):
	push_error("Abstract class: not implemented")


func get_next_detection():
	if detections.size() == 0:
		return null
	
	return detections[0]


func pop_next_detection():
	if detections.size() == 0:
		return null
	
	return detections.pop_front()


func toggle(toggled_on):
	$CollisionShape2D.set_deferred("disabled", toggled_on)


signal detected


# TODO: sort by distance?
func _append_detection(body):
	if not body in detections and _body_is_detected(body):
		detections.append(body)
		emit_signal("detected", body)



func _remove_detection(body):
	var idx = detections.bsearch(body)
	if idx < detections.size():
		detections.remove(idx)


