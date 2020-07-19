extends Detector


func _body_is_detected(body):
	return body.get_entity_type() == Entity.Types.RESOURCE


func _on_ResourceDetector_body_entered(body):
	._append_detection(body)
	

func _on_ResourceDetector_body_exited(body):
	._remove_detection(body)
