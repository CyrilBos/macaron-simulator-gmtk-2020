extends Node


var score = 0

const score_per_second_per_unit = 1

func _process(delta):
	score += delta * score_per_second_per_unit * UnitSpawner.get_unit_count()
	
