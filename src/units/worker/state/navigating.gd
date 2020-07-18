extends Object

class_name Navigator

const RANDOM_POS_SEARCH_DISTANCE = 150

var _path = null

var _last_target = null

	
func follow(cur_pos, target_pos, reach, collided = false):
	
	if target_is_in_range(cur_pos, target_pos, reach):
		_path.pop_front()
		
	# recalculate path if target has moved or we collided
	if collided or _last_target != target_pos:
		_last_target = target_pos
		_path = NavigationManager.compute_path(cur_pos, target_pos)
		
	return _get_direction(cur_pos)
	
	
func target_is_in_range(cur_pos, target_pos, reach):
	if target_pos == null:
		print("[BUG] trying to follow but target was null")
		return false
			
	return _get_distance_between(cur_pos, target_pos) < reach
		


func get_wandering_pos():
	return NavigationManager.get_random_position_inside_viewport(RANDOM_POS_SEARCH_DISTANCE)
	

# returns the movement vector to apply in _ready()
func _get_direction(cur_pos):
	if _path == null:
		print("[BUG] path was null, this should not happen")
		return null
	
	if _path.size() == 0:
		print("Path from %s at %s to %s was empty" %  [self, cur_pos, _last_target])
		return Vector2.ZERO
	
	return _get_distance_vec_between(cur_pos, _path[0]).normalized()

# TODO: move to math helper script?
static func _get_distance_vec_between(pos1, pos2):
	return pos2 - pos1


static func _get_distance_between(pos1, pos2):
	return _get_distance_vec_between(pos1, pos2).length() 
