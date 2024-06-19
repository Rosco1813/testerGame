extends PathFollow2D


var player_near:bool = false
var health:int = 100
var vulnerable:bool = true

@onready var line1: Line2D = $Turret/RayCast2D/Line2D
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D
@onready var GunFire1: Sprite2D = $Turret/GunFire1
@onready var GunFire2: Sprite2D = $Turret/GunFire2
func _ready():
	pass

func _process(delta):
	progress_ratio += 0.01 * delta
	if player_near:
		$Turret.look_at(Globals.player_pos)
#	print($Turret/RayCast2D.get_collider())

func _on_notice_area_body_entered(_body):
	player_near = true
	$AnimationPlayer.play("laser_load")


func fire():
	Globals.health -= 20
	GunFire1.modulate.a = 1
	GunFire2.modulate.a = 1
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(GunFire1, "modulate:a", 0,  randf_range(0.1, 0.5))
	tween.tween_property(GunFire2, "modulate:a", 0,  randf_range(0.1, 0.5))

func _on_notice_area_body_exited(_body):
	player_near = false
	$AnimationPlayer.pause()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(line1, "width", 0, randf_range(0.1, 0.5))
	tween.tween_property(line2, "width", 0, randf_range(0.1, 0.5))
	await tween.finished
	$AnimationPlayer.stop()

func hit():
	$AudioStreamPlayer2D.play()
#	$AudioStreamPlayer2D.play()

	print('CAR health : ', health)
	if vulnerable:
		vulnerable = false
		health -= 10
		$Timers/HitTimer.start()

	if health < 1:
		queue_free()


func _on_hit_timer_timeout() -> void:
	vulnerable = true
