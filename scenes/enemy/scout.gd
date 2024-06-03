extends CharacterBody2D

signal laser(pos, direction)

var player_nearby: bool = false
var can_laser: bool = true
var can_damage:bool = true
var right_laser:bool = true

var health: int = 30


func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var marker_node = $LaserSpawnPosition.get_child(right_laser)
			var pos: Vector2 = marker_node.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			right_laser = !right_laser
			$Timers/LaserTimer.start()
			
func hit():
	print('hit can damage')
	if can_damage:
		health -= 10
		can_damage = false
		$Timers/HitPerFrame.start()
		$Sprite2D.material.set_shader_parameter("progress", 1)
	if health < 1:
		queue_free()
#	print('scout was hit')
	pass

func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

#func _on_laser_cool_down_timeout():
#	can_laser = true



func _on_hit_per_frame_timeout():
#	$HitPerFrame.stop()
	can_damage = true
	


func _on_laser_timer_timeout():
	can_laser = true
	$Sprite2D.material.set_shader_parameter("progress", 0)

