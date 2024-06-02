extends Node2D
class_name LevelParent

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn")
var grenade_scene:PackedScene = preload("res://scenes/projectiles/grenade.tscn")
var item_scene:PackedScene = preload("res://scenes/items/item.tscn")



func _ready():
	for container in get_tree().get_nodes_in_group("Container"):
		print('container : ', container)
		container.connect("open", _on_container_opened)

func _on_container_opened(pos, direction):
	var item = item_scene.instantiate()
	item.position = pos
	print('container opened')
	item.direction = direction
	#call deferred when spawing items ontop of the box messes with physics calc, deferred stops that
	$Items.call_deferred('add_child', item)
	
	
func _on_main_character_shot_pistol(pos, _direction, knownDirection):
	var laser = laser_scene.instantiate() as Area2D
	laser.position = pos
	laser.set_lazer_direction(knownDirection)
	$Projectiles.add_child(laser)

	
func _on_main_character_throw_grendade(pos, direction, knownDirection):
	# godot does not now grenade is a rigid body,
	# give it the type as to get access to linear velocity
	var grenade = grenade_scene.instantiate() as RigidBody2D
	grenade.position = pos
	grenade.linear_velocity =direction * grenade.speed
	grenade.set_grenade_direction(knownDirection)
	$Projectiles.add_child(grenade)





