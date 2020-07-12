extends TextureProgress

export var idle_morale_gain = 5;
export var idle_morale_gain_freq = 1.5;

export var working_morale_loss = 5;
export var working_morale_loss_freq = 1.5;

const MIN_MORALE = 0
const MAX_MORALE = 100

onready var morale_timer = $IdleMoraleTimer
onready var worker = get_parent()
	

var _current_worker_state = null


func _start_idle_morale_gain():
	morale_timer.start(idle_morale_gain_freq)


func _start_working_morale_loss():
	morale_timer.start(working_morale_loss_freq)


func _lose_morale_when_working():
	_reduce_morale(working_morale_loss)


func _gain_morale_when_idle():
	_add_morale(idle_morale_gain)


func _reduce_morale(malus):
	self.set_value(self.get_value() - malus)
	if self.get_value() <= 0:
		worker.GILET_JAUNE()
	
	
func _add_morale(bonus):
	self.set_value(self.get_value() + bonus)
	
	
func _on_IdleMoraleTimer_timeout():
	if _current_worker_state == worker.State.IDLE:
		_gain_morale_when_idle()
	elif _current_worker_state == worker.State.GATHERING:
		_lose_morale_when_working()


func _on_Worker_state_changed(new_state):
	if new_state == worker.State.MOVING:
		return
	
	if new_state == _current_worker_state:
		return
			
	_current_worker_state = new_state
	
	if new_state == worker.State.IDLE && not worker.is_gilet():
		_start_idle_morale_gain()
	elif new_state == worker.State.GATHERING:
		_start_working_morale_loss()


func _on_HealthBar_lost_health(dmg):
	_reduce_morale(dmg)
