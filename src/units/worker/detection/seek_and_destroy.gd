extends Node

onready var worker = get_parent()

var enemies = []

signal new_enemy


func next_enemy():
	if enemies.size() == 0:
		return null
	
	return enemies[0]
	

func contains(target):
	if enemies.size() == 0:
		return false
		
	return enemies.bsearch(target) <= enemies.size()
	
	
func _on_GiletArea_body_entered(body):
	if body.get_entity_type() == Entity.Types.UNIT and body != worker and not contains(body):
		enemies.append(body)
		emit_signal("new_enemy", body)


func _on_Worker_gilet_changed(is_gilet):
	if is_gilet:
		$CollisionShape2D.set_deferred("disabled", false)
	else:
		$CollisionShape2D.set_deferred("disabled", true)


func _on_GiletArea_body_exited(body):
	if body.get_entity_type() == Entity.Types.UNIT:
		var idx = enemies.bsearch(body)
		if idx < enemies.size():
			enemies.remove(idx)
