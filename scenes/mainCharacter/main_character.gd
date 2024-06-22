extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var pistolTimer = $pistolTimer  # Ensure this timer exists
@onready var grenadeTimer = $grenadeTimer
@onready var gunParticlesRight = $gunPartilcesRight

signal shot_pistol(position, direction, knownDirection)
signal throw_grendade(position, direction, knownDirection)

@export var max_speed: int = 500

var speed: int = max_speed
var direction: Vector2 = Vector2.ZERO
var knownDirection = 'down'
var aim: bool = false
var canShoot: bool = true
var roll: bool = true
var rolling_animations = ['roll_down_2', 'roll_up_2', 'roll_left_2', 'roll_right_2']
var shooting_animations = ['shoot_down_2','shoot_up_2','shoot_left_2', 'shoot_right_2']
var aiming_animations = ['aim_down_2','aim_up_2','aim_left_2', 'aim_right_2']

func hit():
	Globals.health -= 10

func _ready():
	set_state("idle")
	pistolTimer.connect("timeout", Callable(self, "_on_pistol_timer_timeout"))

func _process(_delta):
	if roll:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
	if !aim:
		velocity = direction * speed
		move_and_slide()
		Globals.player_pos = global_position
	if direction.y == 1:
		knownDirection = 'down'
	if direction.y == -1:
		knownDirection = 'up'
	if direction.x == 1:
		knownDirection ='right'
	if direction.x == -1:
		knownDirection = 'left'

	update_state()

	if Input.is_action_pressed('aim'):
		direction = Vector2.ZERO
		aim = true
		set_state("aim")
		if Input.is_action_just_pressed("attack") and canShoot and Globals.laser_amount > 0:
			direction = Vector2.ZERO
			var type = 'pistol'
			shoot(type)
	if Input.is_action_just_released("aim"):
		aim = false

	if Input.is_action_just_pressed("roll") and direction != Vector2.ZERO and roll and Globals.stamina > 10 and !aim:
		speed = 1000
		Globals.stamina -= 20
		set_state("roll")

	if Input.is_action_just_pressed("secondary action") and canShoot and Globals.grenade_amount > 0:
		var type = 'grenade'
		shoot(type)

func shoot(type):
	var aim_position: Vector2 = $LaserStartPositions/RightPosition.global_position
	pistolTimer.start()
	gunParticlesRight.emitting = true
	if type == 'pistol':
		Globals.laser_amount -= 1
		shot_pistol.emit(aim_position, direction, knownDirection)
	if type == 'grenade':
		Globals.grenade_amount -= 1
		throw_grendade.emit(aim_position, direction, knownDirection)

	set_state("shoot")
	canShoot = false


func set_state(state: String):
	animationTree["parameters/conditions/is_shooting"] = (state == "shoot")
	animationTree["parameters/conditions/is_rolling"] = (state == "roll")
	animationTree["parameters/conditions/is_aiming"] = (state == "aim")
	animationTree["parameters/conditions/is_walking"] = (state == "walk")
	animationTree["parameters/conditions/is_idle"] = (state == "idle")

	if state == "idle":
		speed = max_speed

func update_state():
	if direction != Vector2.ZERO:
		update_blend_position(direction)
		if !aim:
			set_state("walk")
	else:
		velocity = Vector2.ZERO
		set_state("idle")

func get_direction_from_vector(vector: Vector2) -> String:
	if vector.y == 1:
		return 'down'
	elif vector.y == -1:
		return 'up'
	elif vector.x == 1:
		return 'right'
	elif vector.x == -1:
		return 'left'
	return 'down'

func update_blend_position(blendDirection):
	animationTree["parameters/shoot/blend_position"] = blendDirection
	animationTree["parameters/idle/blend_position"] = blendDirection
	animationTree["parameters/walk/blend_position"] = blendDirection
	animationTree["parameters/roll/blend_position"] = blendDirection
	animationTree["parameters/aim/blend_position"] = blendDirection

func _on_pistol_timer_timeout():
	canShoot = true


func _on_roll_timer_timeout():
	Globals.stamina = min(Globals.stamina + 35, 100)
	if Globals.stamina >= 100:
		$rollTimer.stop()

func _on_animation_tree_animation_finished(anim_name):
	speed = max_speed
	if anim_name in rolling_animations:
		canShoot = true
		roll = true
	if anim_name in shooting_animations:
		aim = false
	if anim_name in aiming_animations:
		canShoot = true

func _on_animation_tree_animation_started(anim_name):
	if anim_name in rolling_animations:
		canShoot = false
		roll = false
		$rollTimer.start()
	elif anim_name in aiming_animations or anim_name in shooting_animations:
		direction = Vector2.ZERO
	if anim_name in shooting_animations:
		aim = true
	if anim_name in aiming_animations:
		canShoot = false

#====================================================================
#====================================================================
#====================================================================

#extends CharacterBody2D
#
#@onready var animationPlayer = $AnimationPlayer
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")
#
#signal shot_pistol(position, direction, knownDirection)
#signal throw_grenade(position, direction)
#
#@export var max_speed: int = 500
#
#var speed: int = max_speed
#var direction: Vector2 = Vector2.ZERO
#var knownDirection = 'down'
#
#var aim: bool = false
#var canShoot: bool = true
#
#var roll: bool = true
#var rolling_animations = ['roll_down_2', 'roll_up_2', 'roll_left_2', 'roll_right_2']
#var shooting_animations = ['shoot_down_2','shoot_up_2','shoot_left_2', 'shoot_right_2']
#var aiming_animations = ['aim_down_2','aim_up_2','aim_left_2', 'aim_right_2']
#
#func hit():
#	Globals.health -= 10
#
#func _ready():
#	set_state("idle")
#
#func _process(_delta):
#	if roll:
#		direction = Input.get_vector("left", "right", "up", "down").normalized()
#
#	if !aim:
#		velocity = direction * speed
#		move_and_slide()
#		Globals.player_pos = global_position
#
#	update_state()
#
#	if Input.is_action_pressed('aim'):
#		set_state("aim")
#		velocity = Vector2.ZERO
#		if Input.is_action_just_pressed("attack") and canShoot and Globals.laser_amount > 0:
#			$pistolTimer.start()
#			Globals.laser_amount -= 1
#			emit_signal("shot_pistol", $LaserStartPositions/RightPosition.global_position, direction, knownDirection)
#
##			$gunParticlesRight.emitting = true
#			$gunPartilcesRight.emitting = true
#			set_state("shoot")
#
#	if Input.is_action_just_pressed("roll") and direction != Vector2.ZERO and roll and Globals.stamina > 10 and !aim:
#		speed = 1000
#		Globals.stamina -= 20
#		set_state("roll")
#
#	if Input.is_action_just_pressed("secondary action") and Globals.grenade_amount > 0 and canShoot:
#		emit_signal("throw_grenade", $LaserStartPositions/RightPosition.global_position, direction, knownDirection)
#		Globals.grenade_amount -= 1
#
#func set_state(state: String):
#	animationTree["parameters/conditions/is_shooting"] = (state == "shoot")
#	animationTree["parameters/conditions/is_rolling"] = (state == "roll")
#	animationTree["parameters/conditions/is_aiming"] = (state == "aim")
#	animationTree["parameters/conditions/is_walking"] = (state == "walk")
#	animationTree["parameters/conditions/is_idle"] = (state == "idle")
#
#	if state == "idle":
#		speed = max_speed
#
#func update_state():
#	if direction != Vector2.ZERO:
#		update_blend_position(direction)
#		if !aim:
#			set_state("walk")
#	else:
#		velocity = Vector2.ZERO
#		set_state("idle")
#
#	knownDirection = get_direction_from_vector(direction)
#
#func get_direction_from_vector(vector: Vector2) -> String:
#	if vector.y == 1:
#		return 'down'
#	elif vector.y == -1:
#		return 'up'
#	elif vector.x == 1:
#		return 'right'
#	elif vector.x == -1:
#		return 'left'
#	return 'down'
#
#func update_blend_position(blendDirection):
#	animationTree["parameters/shoot/blend_position"] = blendDirection
#	animationTree["parameters/idle/blend_position"] = blendDirection
#	animationTree["parameters/walk/blend_position"] = blendDirection
#	animationTree["parameters/roll/blend_position"] = blendDirection
#	animationTree["parameters/aim/blend_position"] = blendDirection
#
#func _on_pistol_timer_timeout():
#	canShoot = true
#
#func _on_roll_timer_timeout():
#	Globals.stamina = min(Globals.stamina + 35, 100)
#	if Globals.stamina >= 100:
#		$rollTimer.stop()
#
#func _on_animation_tree_animation_finished(anim_name):
#	speed = max_speed
#	if anim_name in rolling_animations:
#		canShoot = true
#		roll = true
#
#func _on_animation_tree_animation_started(anim_name):
#	if anim_name in rolling_animations:
#		canShoot = false
#		roll = false
#		$rollTimer.start()
#	elif anim_name in aiming_animations or anim_name in shooting_animations:
#		direction = Vector2.ZERO
#
#
#



#====================================================================
#====================================================================
#====================================================================
#extends CharacterBody2D
#
#@onready var animationPlayer = $AnimationPlayer
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")
#
#signal shot_pistol(position, direction, knownDirection)
#signal throw_grendade(position, direction)
#
#@export var max_speed: int = 500
#
#var speed: int = max_speed
#var direction: Vector2 = Vector2.ZERO
#var knownDirection = 'down';
#
#var aim: bool = false
#var shoot: bool = false
#var canShoot: bool = true
#
#var roll: bool = true
#var rolling = ['roll_down_2', 'roll_up_2', 'roll_left_2', 'roll_right_2']
#var shooting_animation = ['shoot_down_2','shoot_up_2','shoot_left_2', 'shoot_right_2']
#var aiming_animation = ['aim_down_2','aim_up_2','aim_left_2', 'aim_right_2']
#var walk: bool = false
#var idle: bool = false
#
#var aiming: bool = false
#
#func hit():
#	Globals.health -= 10
#
#func _ready():
#	set_walking(false)
#	set_idle(true)
#
#func _process(_delta):
#
##	print('Direction : ', direction)
##	print('Velocity : ', velocity)
#	if roll:
#		direction = Input.get_vector("left", "right", "up", "down").normalized()
#
#	if !aim and !shoot:
#		velocity = direction * speed
#
#		move_and_slide()
#		Globals.player_pos = global_position
#
#	if direction != Vector2.ZERO:
#		update_blend_position(direction)
#		if not aim and not shoot:
#
#			set_walking(true)
#			set_idle(false)
#	else:
#		velocity = Vector2.ZERO
#
#		set_idle(true)
#		set_walking(false)
#		set_aim(false)
#		set_roll(false)
#		set_shoot(false)
#
#	if direction.y == 1:
#		knownDirection = 'down'
#	if direction.y == -1:
#		knownDirection = 'up'
#	if direction.x == 1:
#		knownDirection ='right'
#	if direction.x == -1:
#		knownDirection = 'left'
#
#	if Input.is_action_pressed('aim'):
#		aiming = true
#
#		set_walking(false)
#		set_idle(false)
#		set_roll(false);
#		set_aim(true)
#
##	if Input.is_action_just_released("aim"):
##		aiming = false
##		set_aim(false)
#
#	if Input.is_action_just_pressed("attack") and aiming:
##		$stopAimTimer.start()
##		canAim = false
#		if canShoot and Globals.laser_amount > 0:
##			canShoot= false
#			$pistolTimer.start()
#			var aim_position: Vector2 = $LaserStartPositions/RightPosition.global_position
#			Globals.laser_amount -= 1
#			shot_pistol.emit(aim_position, direction, knownDirection)
#			$gunPartilcesRight.emitting = true
#			set_shoot(true)
#
#		set_walking(false)
#		set_idle(false)
#
#		if canShoot:
#			canShoot = false
#
#
#	if Input.is_action_just_pressed("roll") and direction and roll and Globals.stamina > 10 and not aim:
#		speed = 1000
#		if canShoot:
#			Globals.stamina -= 20
#		if Globals.stamina < 0:
#			Globals.stamina = 0
#		set_shoot(false)
#		set_roll(true)
#
#	if Input.is_action_just_pressed("secondary action") and Globals.grenade_amount > 0 and canShoot:
#		var aim_position: Vector2 = $LaserStartPositions/RightPosition.global_position
#		throw_grendade.emit(aim_position, direction, knownDirection)
#		Globals.grenade_amount -= 1
#
#func set_shoot(value=false):
#	shoot = value
##	velocity = Vector2.ZERO
#	animationTree["parameters/conditions/is_shooting"] = value
#
#func set_roll(value=false):
#	animationTree["parameters/conditions/is_rolling"] = value
#
#func set_aim(value=false):
#	aim = value
#	animationTree["parameters/conditions/is_shooting"] = not value
#	animationTree["parameters/conditions/is_aiming"] = value
#
#func set_walking(value=false):
#	walk = value
#	animationTree["parameters/conditions/is_walking"] = value
#
#func set_idle(value):
#	idle = value
#	animationTree["parameters/conditions/is_idle"] = value
#	if value:
#		speed = max_speed
#
#func _on_pistol_timer_timeout():
#	canShoot = true
##	print('pistol timer : ', canShoot)
#
##func _on_grenade_timer_timeout():
##	grenades = 4
#
#func update_blend_position(blendDirection):
#	if not Input.is_action_pressed("aim"):
#		set_aim(false)
#		set_shoot(false)
#	if not Input.is_action_pressed("roll"):
#		set_roll(false)
#	animationTree["parameters/shoot/blend_position"] = blendDirection
#	animationTree["parameters/idle/blend_position"] = blendDirection
#	animationTree["parameters/walk/blend_position"] = blendDirection
#	animationTree["parameters/roll/blend_position"] = blendDirection
#	animationTree["parameters/aim/blend_position"] = blendDirection
#
#func _on_animation_tree_animation_finished(anim_name):
#		speed = max_speed
##		print('FINISHED : ', speed)
#		for r in rolling:
#			if r == anim_name:
#				canShoot = true
#				roll = true
#				speed = max_speed
#
#
#func _on_animation_tree_animation_started(anim_name):
#
#	for r in rolling:
#		if r == anim_name:
#			canShoot = false
#			roll = false
#			$rollTimer.start()
#		for a in aiming_animation:
#			if a == anim_name:
#				direction = Vector2()
#		for s in shooting_animation:
#			if s == anim_name:
#				direction = Vector2.ZERO
##				print('STARTED : ', anim_name )
#
#
#
##stamina timer
#func _on_roll_timer_timeout():
#	if Globals.stamina >= 100:
#		$rollTimer.stop()
#	if Globals.stamina < 100:
#		Globals.stamina += 35
#
#
#
#
#
#
#
#
#
#

