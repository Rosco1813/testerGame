extends CharacterBody2D


signal laser(pos, direction)

var SPEED = 100.0

var player_nearby: bool = false
var can_laser: bool = true


func _process(_delta):
#	var direction = Vector2.RIGHT
#	velocity = direction * SPEED
#	move_and_slide()
	if player_nearby:
		look_at(Globals.player_pos)
		if can_laser:
			var pos: Vector2 = $LaserSpawnPosition/Marker2D.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$LaserCoolDown.start()
	
func hit():
#	print('drone was hit')
	pass
#	queue_free()

func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

func _on_laser_cool_down_timeout():
	can_laser = true
