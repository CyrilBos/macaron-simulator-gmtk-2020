extends Object

const RANDOM_POS_SEARCH_DISTANCE = 150


var _nav_manager = null

var _path = null

var _last_target = null


var _mvt_tgt_pos = null 
#TODO: remove _target_node from here and care only baout target pos
var _target_node = null


func move_to(pos):
	_mvt_tgt_pos = pos


func get_target():
	return _target_node



func target(targeted):
	_target_node = targeted
	_mvt_tgt_pos = targeted.get_global_position()


func seek(enemy, seek_enemy_sound): # private?
	if enemy == null:
		print("[BUG] trying to seek a null enemy")
		return
	
	if enemy != _target_node:
		print("gilet %s seeks %s" % [self, enemy])
		seek_enemy_sound.play()
		
		target(enemy)

		
func follow(cur_pos, is_moving, reach, collided = false):
	var target_pos = get_target_pos(is_moving)
	
	if _path == null:
		_assign_path(cur_pos, target_pos)
	
	if target_is_in_range(cur_pos, target_pos, reach):
		if _path.size() > 0:
			_path.pop_front()
		
	# recalculate path if target has moved or we collided
	if collided or _last_target != _mvt_tgt_pos:
		_last_target = _mvt_tgt_pos
		_assign_path(cur_pos, target_pos)
		
	return _get_direction(cur_pos)
	
	
func target_is_in_range(cur_pos, is_moving, reach):
	var target_pos = get_target_pos(is_moving)
	
	if target_pos == null:
		print("[BUG] trying to follow but target was null")
		return false
			
	return _get_distance_between(cur_pos, target_pos) < reach


func get_wandering_pos():
	return _nav_manager.get_random_position_inside_viewport(RANDOM_POS_SEARCH_DISTANCE)


func get_target_pos(is_moving):
	if _target_node == null and not is_moving:
		print("[BUG] tried to get null target node in SEEKING")
		return null

	return _mvt_tgt_pos if is_moving else _target_node.get_global_position()


func get_direction(pos1, pos2):
	return _get_distance_vec_between(pos1, pos2).normalized()


func _init():
	_nav_manager = SceneFinder.get_navigation_manager()
	

func _assign_path(cur_pos, tgt_pos):
	_path = _nav_manager.compute_path(cur_pos, tgt_pos)


# returns the movement vector to apply in _ready()
func _get_direction(cur_pos):
	if _path == null:
		print("[BUG] path was null, this should not happen")
		return null
	
	if _path.size() == 0:
		print("Path from %s at %s to %s was empty" %  [self, cur_pos, _last_target])
		return Vector2.ZERO
	
	return _get_distance_vec_between(cur_pos, _path[0]).normalized()


static func _get_distance_between(pos1, pos2):
	return _get_distance_vec_between(pos1, pos2).length() 


# TODO: move to math helper script?
static func _get_distance_vec_between(pos1, pos2):
	return pos2 - pos1


