extends CharacterBody2D


signal laser(pos, direction)

var speed = 100.0
var player_nearby: bool = false
var can_laser: bool = true
var can_damage:bool = true
var health:int = 40



func _ready():
	$Explosions.hide()
	$DroneImage.show()


func _process(delta):
	var direction: Vector2 = (Globals.player_pos - position).normalized()
	speed += 5
	velocity = direction * speed
	if player_nearby:
		look_at(Globals.player_pos)
#		move_and_slide()
		var collision = move_and_collide(velocity * delta)
		print('collision : ', collision)
		if collision:
			Globals.health -=10
			$AnimationPlayer.play("explosion")
		if can_laser:
			var pos: Vector2 = $LaserSpawnPosition/Marker2D.global_position
#			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$Timers/LaserCoolDown.start()



	
func hit():
	if can_damage:
		health -= 10
		can_damage = false
		$Timers/HitPerFrame.start()
		$DroneImage.material.set_shader_parameter("progress", 1)
	if health < 1:
		$AnimationPlayer.play("explosion")


func _on_attack_area_body_entered(_body):
	player_nearby = true

func _on_attack_area_body_exited(_body):
	player_nearby = false

func _on_laser_cool_down_timeout():
	can_laser = true

func _on_hit_per_frame_timeout():
	can_damage = true
	$DroneImage.material.set_shader_parameter("progress", 0)
