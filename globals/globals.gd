extends Node

signal stat_change

var laser_amount = 99:
	get:
		return laser_amount
	set(value):
		laser_amount = value
		stat_change.emit()

var grenade_amount = 99:
	get:
		return grenade_amount
	set(value):
		grenade_amount = value
		stat_change.emit()

var shotgun_amount = 4:
	get:
		return shotgun_amount
	set(value):
		shotgun_amount = value
		stat_change.emit()
		
var stamina = 100:
	get:
		return stamina
	set(value):
		stamina = value
		stat_change.emit()
var can_damage:bool = true
var health = 60:
	get:
		return health
	set(value):
		if value > health:
			health = min(value, 100)
		else:
			if can_damage:
				can_damage = false
				player_i_frames_timer()
				health = max(value, 0)
		stat_change.emit()

var player_pos: Vector2

func player_i_frames_timer():
	await get_tree().create_timer(0.5).timeout
	can_damage = true
	
