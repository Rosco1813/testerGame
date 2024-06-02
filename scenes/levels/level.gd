extends Node2D
class_name LevelParent

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene:PackedScene = preload("res://scenes/projectiles/grenade.tscn")



func _on_main_character_shot_pistol(pos, _direction, knownDirection):
	var laser = laser_scene.instantiate() as Area2D
	laser.position = pos
	laser.set_lazer_direction(knownDirection)
	$Projectiles.add_child(laser)
	$UI.update_laser_text()
	
func _on_main_character_throw_grendade(pos, direction, knownDirection):
	# godot does not now grenade is a rigid body,
	# give it the type as to get access to linear velocity
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity =direction * grenade.speed
	grenade.set_grenade_direction(knownDirection)
	$Projectiles.add_child(grenade)
	$UI.update_grenade_text()







	


func _on_main_character_update_stats():
	$UI.update_laser_text()
	$UI.update_grenade_text()
