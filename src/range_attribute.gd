class_name RangeAttribute

var _min_val = 0
var _max_val = 100
var _cur_val = _min_val

func _init(min_val, max_val, cur_val=null):
	_min_val = min_val
	_max_val = max_val
	
	_cur_val = cur_val if cur_val else min_val
		
