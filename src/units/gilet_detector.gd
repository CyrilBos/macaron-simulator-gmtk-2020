extends Detector


func _body_is_detected(body):
	return body.get_entity_type() == Entity.Types.UNIT and body.is_gilet()

func _on_GiletDetector_area_shape_entered(area_id, area, area_shape, self_shape):
	pass # Replace with function body.


func _on_GiletDetector_area_shape_exited(area_id, area, area_shape, self_shape):
	pass # Replace with function body.


func _on_GiletDetector_body_entered(body):
	pass # Replace with function body.


func _on_GiletDetector_body_exited(body):
	pass # Replace with function body.
