extends Object

var _max_amount
var _cur_amount

func reduce_amount(harvest_speed):
	_cur_amount -= harvest_speed
	if (_cur_amount < 0):
		_cur_amount = 0

func is_gathered():
	return _cur_amount <= 0
		

func _init(max_amount):
	_max_amount = max_amount
	_cur_amount = max_amount
