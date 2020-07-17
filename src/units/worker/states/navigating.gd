extends Navigation2D

var path = null

var last_target = null
	
	
func follow(target_pos, reach, collided = false):
	if target_in_range(target_pos, reach):
		return Vector2.ZERO
		
	# recalculate path if target has moved or we collided
	if collided or last_target != target_pos:
		last_target = target_pos
		_compute_path(target_pos)
		
	return _get_direction()
	
	
func is_reachable(target_pos, reach):
	return _get_distance_to(target_pos) < reach
	
	
func target_in_range(target_pos, reach):
	if target_pos == null:
		print("[BUG] trying to follow but target was null")
		return true
			
	return is_reachable(target_pos, reach)
		
	
# returns the movement vector to apply in _ready()
func _get_direction():
	if path == null:
		print("[BUG] path was null, this should not happen")
		return null
	
	if path.size() == 0:
		print("Path from %s at %s to %s was empty", self, self.get_global_position(), last_target)
		return Vector2.ZERO
	
	var cur_pos = self.get_global_position()
	var cur_sub_tgt = path[0]
	
	return cur_sub_tgt - cur_pos


func _compute_path(target_pos):
	path = get_simple_path(self.get_global_position(), target_pos)


func _get_distance_vec_to(position):
	return position - self.global_position


func _get_distance_to(position):
	if position == null:
		return 0
	
	return _get_distance_vec_to(position).length() 
