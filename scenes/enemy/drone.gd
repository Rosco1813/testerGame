extends CharacterBody2D


signal laser(pos, direction)

var max_speed :int = 600
var speed : int= 0
var speed_multiplier: int = 1
var player_nearby: bool = false
var can_laser: bool = true
var can_damage:bool = true
var health:int = 10
var explosion_active:bool = false



func _ready():
	$Explosions.hide()
	$DroneImage.show()


func _process(delta):
	var direction: Vector2 = (Globals.player_pos - position).normalized()

	velocity = direction * speed * speed_multiplier
	if player_nearby:
		look_at(Globals.player_pos)
		var collision = move_and_collide(velocity * delta)
#		print('collision : ', collision)
		if collision:
			explosion_active = true
			Globals.health -=10

			$AnimationPlayer.play("explosion")
		if can_laser and health > 1:
			var pos: Vector2 = $LaserSpawnPosition/Marker2D.global_position
#			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)
			can_laser = false
			$Timers/LaserCoolDown.start()
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < 400

			if in_range and "hit" in target:
				target.hit()

func stop_movement():
	speed_multiplier = 0


func hit():
	$Sounds/HitSound.play()
	if can_damage:
		health -= 10
		can_damage = false
		$Timers/HitPerFrame.start()
		$DroneImage.material.set_shader_parameter("progress", 1)
	if health < 1:
		$Sounds/Explosion.play()
#		$AnimationPlayer.play("explosion")
		explosion_active = true


func _on_attack_area_body_entered(_body):
	player_nearby = true
	var tween = create_tween()
	tween.tween_property(self, "speed", max_speed, 6)

func _on_attack_area_body_exited(_body):
	player_nearby = false

func _on_laser_cool_down_timeout():
	can_laser = true

func _on_hit_per_frame_timeout():
	can_damage = true
	$DroneImage.material.set_shader_parameter("progress", 0)
