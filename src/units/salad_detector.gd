extends Area2D

onready var worker = get_parent()

signal resource_detected

var salads = []

func next_salad():
	if salads.size() == 0:
		return null
	
	return salads.pop_front()


func contains(salad):
	if salads.size() == 0:
		return false
	
	return salads.bsearch(salad) <= salads.size()


func _is_body_salad(body):
	return body.get_entity_type() == Entity.Types.RESOURCE


func _on_SaladDetector_body_entered(body):
	if body != worker and _is_body_salad(body) and not contains(body):
		salads.append(body)
		emit_signal("resource_detected", body)


func _on_SaladDetector_body_exited(body):
	if _is_body_salad(body):
		var salad_idx = salads.bsearch(body)
		if salad_idx >= salads.size():
			return
		else:
			salads.remove(salad_idx)
