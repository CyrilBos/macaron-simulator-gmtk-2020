extends Node

onready var worker = get_parent()


func _on_GiletArea_body_entered(body):
	if body.get_entity_type() == Entity.Types.UNIT:
		worker.seek(body)


func _on_Worker_state_changed(new_state):
	if new_state == worker.State.GILET:
		$CollisionShape2D.set_deferred("disabled", false)
		
	else:
		$CollisionShape2D.set_deferred("disabled", true)
