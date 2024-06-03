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
		
var health = 60:
	get:
		return health
	set(value):
		health = value
		stat_change.emit()

var player_pos: Vector2
