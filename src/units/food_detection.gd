extends Area2D

signal resource_detected

var salads = []

func get_next_detected_salad():
	if salads.size() == 0:
		return null
	
	return salads[0]

func _is_body_salad(body):
	return body.get_entity_type() == Entity.Types.RESOURCE


func _on_FoodDetectionArea_body_entered(body):
	if _is_body_salad(body):
		salads.append(body)
		emit_signal("resource_detected", body)


func _on_FoodDetectionArea_body_exited(body):
	if _is_body_salad(body):
		salads.remove(salads.bsearch(body))
