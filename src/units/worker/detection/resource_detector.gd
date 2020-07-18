extends Area2D

onready var worker = get_parent()

signal resource_detected

var resources = []

func next_resource():
	if resources.size() == 0:
		return null
	
	return resources.pop_front()


func _is_body_a_resource(body):
	return body.get_entity_type() == Entity.Types.RESOURCE


# TODO: sort by distance?
func _on_ResourceDetector_body_entered(body):
	if body != worker and _is_body_a_resource(body) and not body in resources:
		resources.append(body)
		emit_signal("resource_detected", body)


func _on_ResourceDetector_body_exited(body):
	if _is_body_a_resource(body):
		var resource_idx = resources.bsearch(body)
		if resource_idx >= resources.size():
			return
		else:
			resources.remove(resource_idx)
