extends Area2D

signal resource_detected

func _on_FoodDetectionArea_body_entered(body):
	if body.get_entity_type() == Entity.Types.RESOURCE:
		print("%s detected resource %s" % [self, body])
		emit_signal("resource_detected", body)
