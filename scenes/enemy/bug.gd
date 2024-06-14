extends CharacterBody2D

signal laser(pos, direction)

var player_nearby: bool = false
var can_take_damage: bool = true
var can_attack: bool = true
var active:bool = false
var speed:int = 300
var health: int = 10

func _process(_delta):
	var direction: Vector2 = (Globals.player_pos - position).normalized()
	velocity = direction * speed
	if active:
		look_at(Globals.player_pos)
		move_and_slide()

func hit():
	if can_take_damage:
		can_take_damage = false
		health -= 10
		$Timers/HitPerFrame.start()
		$AnimatedSprite2D.material.set_shader_parameter("progress", 1)
		$Particles/HitParticles.emitting = true
	if health < 1:
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _on_hit_per_frame_timeout():
	can_take_damage = true
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)

func _on_attack_cool_down_timeout():
	$AnimatedSprite2D.play("attack")
	
func _on_attack_area_2d_body_entered(_body):
	player_nearby = true
	$AnimatedSprite2D.play('attack')

func _on_attack_area_2d_body_exited(_body):
	player_nearby = false

func _on_notice_area_2d_body_entered(_body):
	active = true
	$AnimatedSprite2D.play("walk")

func _on_notice_area_2d_body_exited(_body):
	active = false
	$AnimatedSprite2D.stop()

func _on_animated_sprite_2d_animation_finished():
	if player_nearby:
		Globals.health -= 10
		$Timers/AttackCoolDown.start()
