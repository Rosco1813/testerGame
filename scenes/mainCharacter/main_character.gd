extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

signal shot_pistol(position, direction, knownDirection)
signal throw_grendade(position, direction)

@export var max_speed: int = 500

var speed: int = max_speed
var direction: Vector2 = Vector2.ZERO
var knownDirection = 'down';
var aim: bool = false
var shoot: bool = false
var canShoot: bool = true
var roll: bool = true
var rolling = ['roll_down_2', 'roll_up_2', 'roll_left_2', 'roll_right_2']
var walk: bool = false
var idle: bool = false

func hit():
	Globals.health -= 10

func _ready():
	set_walking(false)
	set_idle(true)

func _process(delta):
	var aim_position: Vector2 = $LaserStartPositions/RightPosition.global_position
#	print('Direction : ', direction)
#	print('Velocity : ', velocity)
	if roll:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
		
	if !aim and !shoot:
		velocity = direction * speed
		move_and_slide()
		Globals.player_pos = global_position
		
	if direction != Vector2.ZERO:
		update_blend_position(direction)
		if not aim and not shoot:
			set_walking(true)
			set_idle(false)
	else:
		velocity = Vector2.ZERO
		set_idle(true)
		set_walking(false)
		set_aim(false)
		set_roll(false)
		set_shoot(false)
			
	if direction.y == 1:
		knownDirection = 'down'
	if direction.y == -1:
		knownDirection = 'up'
	if direction.x == 1:
		knownDirection ='right'
	if direction.x == -1:
		knownDirection = 'left'
		
	if Input.is_action_pressed('aim'):
		set_aim(true)
		set_walking(false)
		set_idle(false)
		set_roll(false);

	if Input.is_action_just_pressed("attack") and aim:
		if canShoot and Globals.laser_amount > 0:
			Globals.laser_amount -= 1
			shot_pistol.emit(aim_position, direction, knownDirection)
			$gunPartilcesRight.emitting = true
			set_shoot(true)
		set_walking(false)
		set_idle(false)
		
		if canShoot:
			canShoot = false
			$pistolTimer.start()
	
	if Input.is_action_just_pressed("roll") and direction and roll and Globals.stamina > 10:
		speed = 1000
		if canShoot:
			Globals.stamina -= 20
		if Globals.stamina < 0:
			Globals.stamina = 0
		set_shoot(false)
		set_roll(true)

	if Input.is_action_just_pressed("secondary action") and Globals.grenade_amount > 0 and canShoot:
		throw_grendade.emit(aim_position, direction, knownDirection)
		Globals.grenade_amount -= 1
		
func set_shoot(value=false):
	shoot = value
	animationTree["parameters/conditions/is_shooting"] = value

func set_roll(value=false):
	animationTree["parameters/conditions/is_rolling"] = value

func set_aim(value=false):
	aim = value
	animationTree["parameters/conditions/is_shooting"] = not value
	animationTree["parameters/conditions/is_aiming"] = value

func set_walking(value=false):
	walk = value
	animationTree["parameters/conditions/is_walking"] = value
	
func set_idle(value):
	idle = value
	animationTree["parameters/conditions/is_idle"] = value
	if value:
		speed = max_speed
		
func _on_pistol_timer_timeout():
	canShoot = true

#func _on_grenade_timer_timeout():
#	grenades = 4

func update_blend_position(blendDirection):
	if not Input.is_action_pressed("aim"):
		set_aim(false)
		set_shoot(false)
	if not Input.is_action_pressed("roll"):
		set_roll(false)
	animationTree["parameters/shoot/blend_position"] = blendDirection
	animationTree["parameters/idle/blend_position"] = blendDirection
	animationTree["parameters/walk/blend_position"] = blendDirection
	animationTree["parameters/roll/blend_position"] = blendDirection
	animationTree["parameters/aim/blend_position"] = blendDirection

func _on_animation_tree_animation_finished(anim_name):
		speed = max_speed
#		print('FINISHED : ', speed)
		for r in rolling:
			if r == anim_name:
				canShoot = true
				roll = true
				speed = max_speed
				

func _on_animation_tree_animation_started(anim_name):
#	print('STARTED : ', speed )
	for r in rolling:
		if r == anim_name:
			canShoot = false
			roll = false
			$rollTimer.start()

#stamina timer 
func _on_roll_timer_timeout():
	if Globals.stamina >= 100:
		$rollTimer.stop()
	if Globals.stamina < 100:
		Globals.stamina += 35





