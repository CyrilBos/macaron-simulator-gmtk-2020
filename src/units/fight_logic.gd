extends TextureProgress

export var damage = 5
export var atk_freq = 0.5
export var max_health = 100

var health = RangeAttribute.new(0, max_health)

onready var attackTimer = $AttackTimer

var target = null
var in_range = false

signal death

func fight(to_fight):
	if target == null:
		target = to_fight
	
	attackTimer.start(atk_freq)
	in_range = true


func stop_fighting():
	target = null
	attackTimer.stop()

func lose_health(dmg):
	self.set_value(self.get_value() - dmg)
	
	if self.get_value() <= 0:
		emit_signal("death", self)

func _attack():
	if target == null || not in_range:
		return
	
	var dmg = rand_range(damage / 2, damage)
	target.lose_health(dmg)


func _on_AttackTimer_timeout():
	_attack()

func _on_Worker_target_out_of_reach():
	in_range = false
