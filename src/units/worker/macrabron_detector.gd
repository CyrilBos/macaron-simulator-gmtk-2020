extends Node


func _body_is_detected(body):
	return body.get_entity_type() == Entity.Types.ENEMY


func _on_MacrabronDetector_body_entered(body):
	pass # Replace with function body.


func _on_MacrabronDetector_body_exited(body):
	pass # Replace with function body.
