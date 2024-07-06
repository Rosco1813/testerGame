#extends CharacterBody2D
#
#@onready var animationPlayer = $AnimationPlayer
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")
#@onready var pistolTimer = $pistolTimer  # Ensure this timer exists
#@onready var grenadeTimer = $grenadeTimer
#@onready var gunParticlesRight = $gunPartilcesRight
#@onready var cursor = $Cursor
#@onready var cursorBoundary = $CursorBoundary
#@onready var cursorBoundaryShape = $CursorBoundary/CollisionShape2D
#
#signal shot_pistol(position, direction)
#signal throw_grendade(position, direction, knownDirection)
#
#@export var max_speed: int = 500
#@export var cursor_speed: float = 300.0
#
#var speed: int = max_speed
#var direction: Vector2 = Vector2.ZERO
#var knownDirection = 'down'
#var aim: bool = false
#var canShoot: bool = true
#var roll: bool = true
#var rolling_animations = ['roll_down_2', 'roll_up_2', 'roll_left_2', 'roll_right_2']
#var shooting_animations = ['shoot_down_2', 'shoot_up_2', 'shoot_left_2', 'shoot_right_2']
#var aiming_animations = ['aim_down_2', 'aim_up_2', 'aim_left_2', 'aim_right_2']
#
#func hit():
#	Globals.health -= 10
#
#func _ready():
#	set_state("idle")
#	pistolTimer.connect("timeout", Callable(self, "_on_pistol_timer_timeout"))
#
#func _process(delta):
#	handle_cursor_movement(delta)
#	handle_player_movement(delta)
#	update_state()
#
#func handle_cursor_movement(delta):
#	if aim:
#		var cursor_velocity = Vector2.ZERO
#		if Input.is_action_pressed("left"):
#			cursor_velocity.x -= 1
#		if Input.is_action_pressed("right"):
#			cursor_velocity.x += 1
#		if Input.is_action_pressed("up"):
#			cursor_velocity.y -= 1
#		if Input.is_action_pressed("down"):
#			cursor_velocity.y += 1
#
#		if cursor_velocity.length() > 0:
#			cursor_velocity = cursor_velocity.normalized() * cursor_speed
#			cursor.position += cursor_velocity * delta
#			clamp_cursor_position()
#
#func handle_player_movement(_delta):
#	if roll:
#		direction = Input.get_vector("left", "right", "up", "down").normalized()
#		print('roll roll roll = ', roll, )
#	if !aim:
#		velocity = direction * speed
#		move_and_slide()
#		Globals.player_pos = global_position
#
#	if Input.is_action_pressed('aim'):
#		direction = Vector2.ZERO
#		aim = true
#		set_state("aim")
#		if Input.is_action_just_pressed("attack") and canShoot and Globals.laser_amount > 0:
#			direction = Vector2.ZERO
#			var type = 'pistol'
#			shoot(type)
#	if Input.is_action_just_released("aim"):
#		aim = false
#
#	if Input.is_action_just_pressed("roll") and direction != Vector2.ZERO and roll and Globals.stamina > 10 and !aim:
#		speed = 1000
#		Globals.stamina -= 20
#		print('ROLL TIME')
#		set_state("roll")
#
#	if Input.is_action_just_pressed("secondary action") and canShoot and Globals.grenade_amount > 0:
#		var type = 'grenade'
#		shoot(type)
#
#func shoot(type):
#	var aim_position: Vector2 = $LaserStartPositions/RightPosition.global_position
#	pistolTimer.start()
#	gunParticlesRight.emitting = true
#	if type == 'pistol':
#		direction = (Globals.cursor_pos - global_position).normalized()
#		Globals.laser_amount -= 1
#		shot_pistol.emit(aim_position, direction)
#	if type == 'grenade':
#		Globals.grenade_amount -= 1
#		throw_grendade.emit(aim_position, direction, knownDirection)
#	set_state("shoot")
#	canShoot = false
#
#func set_state(state: String):
#	if state == 'walk':
#		Globals.player_walking = true
#	else:
#		Globals.player_walking = false
#	if state == "idle":
#		Globals.player_idle = true
#	else:
#		Globals.player_idle = false
#
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
#	animationTree["parameters/idle/blend_position"] = blendDirection
#	animationTree["parameters/walk/blend_position"] = blendDirection
#	animationTree["parameters/roll/blend_position"] = blendDirection
#
#func clamp_cursor_position():
#	if cursorBoundaryShape.shape is RectangleShape2D:
#		var rect_shape = cursorBoundaryShape.shape
#		var boundary_pos = cursorBoundary.global_position
#		var extents = rect_shape.extents
#		var min_x = boundary_pos.x - extents.x
#		var max_x = boundary_pos.x + extents.x
#		var min_y = boundary_pos.y - extents.y
#		var max_y = boundary_pos.y + extents.y
#		var global_cursor_pos = cursor.global_position
#		global_cursor_pos.x = clamp(global_cursor_pos.x, min_x, max_x)
#		global_cursor_pos.y = clamp(global_cursor_pos.y, min_y, max_y)
#		cursor.position = cursor.get_parent().to_local(global_cursor_pos)
#
#func _on_pistol_timer_timeout():
#	canShoot = true
#
#func _on_roll_timer_timeout():
#	print('roll Timer')
#	Globals.stamina = min(Globals.stamina + 35, 100)
#	if Globals.stamina >= 100:
#		$rollTimer.stop()
#
#func _on_animation_tree_animation_finished(anim_name):
#
#	speed = max_speed
#	if anim_name in rolling_animations:
#		canShoot = true
#		roll = true
#	if anim_name in shooting_animations:
#		aim = false
#	if anim_name in aiming_animations:
#		canShoot = true
#
#func _on_animation_tree_animation_started(anim_name):
#	if anim_name in rolling_animations:
#		canShoot = false
#		roll = false
#		$rollTimer.start()
#	elif anim_name in aiming_animations or anim_name in shooting_animations:
#		direction = Vector2.ZERO
#	if anim_name in shooting_animations:
#		aim = true
#	if anim_name in aiming_animations:
#		canShoot = false
#
#func _on_cursor_area_right_body_entered(_body: Node2D) -> void:
#	var right: Vector2 = Vector2(1, 0)
#	animationTree["parameters/aim/blend_position"] = right
#	animationTree["parameters/shoot/blend_position"] = right
##	print('Right : : enter : : ', body.name)
#
#func _on_cursor_area_right_body_exited(_body: Node2D) -> void:
#	pass
#
#func _on_cursor_area_left_body_entered(_body: Node2D) -> void:
#	var left: Vector2 = Vector2(-1, 0)
#	animationTree["parameters/aim/blend_position"] = left
#	animationTree["parameters/shoot/blend_position"] = left
##	print('Left : : enter : : ', body.name)
#
#func _on_cursor_area_left_body_exited(_body: Node2D) -> void:
#	pass
#
#func _on_curso_area_up_body_entered(_body: Node2D) -> void:
#	var up: Vector2 = Vector2(0, -1)
#	animationTree["parameters/aim/blend_position"] = up
#	animationTree["parameters/shoot/blend_position"] = up
##	print('UP : : enter : : ', body.name)
#
#func _on_curso_area_up_body_exited(_body: Node2D) -> void:
#	pass
#
#func _on_cursor_area_down_body_entered(_body: Node2D) -> void:
#	var down: Vector2 = Vector2(0, 1)
#	animationTree["parameters/aim/blend_position"] = down
#	animationTree["parameters/shoot/blend_position"] = down
##	print('Down : : enter : : ', body.name)
#
#func _on_cursor_area_down_body_exited(_body: Node2D) -> void:
#	pass


##====================================================================
##====================================================================
##====================================================================
extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var pistolTimer = $pistolTimer  # Ensure this timer exists
@onready var grenadeTimer = $grenadeTimer
@onready var gunParticlesRight = $gunPartilcesRight
@onready var cursor = $Cursor
#@onready var cursorAreaRight = $CursorAreaRight



signal shot_pistol(position, direction)
signal throw_grendade(position, direction, knownDirection)

@export var max_speed: int = 500
@export var cursor_speed: float = 300.0

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
#	cursorAreaRight.connect('area_entered', Callable(self, "_on_cursor_area_right_area_entered"))
	pistolTimer.connect("timeout", Callable(self, "_on_pistol_timer_timeout"))

func _process(delta):

	if roll:
		direction = Input.get_vector("left", "right", "up", "down").normalized()
	if !aim:
		velocity = direction * speed
		move_and_slide()
		Globals.player_pos = global_position
	update_state()
#	if direction.y == 1:
#		knownDirection = 'down'
#	if direction.y == -1:
#		knownDirection = 'up'
#	if direction.x == 1:
#		knownDirection ='right'
#	if direction.x == -1:
#		knownDirection = 'left'
	if Input.is_action_pressed('aim'):
#		var testDirection= (Globals.cursor_pos - global_position ).normalized()
#		print('aiming cursor position ', testDirection)

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
		direction= (Globals.cursor_pos - global_position ).normalized()
		Globals.laser_amount -= 1

		shot_pistol.emit(aim_position, direction)
#		direction = (Globals.cursor_pos - Globals.player_pos)
#		aim_position = Globals.cursor_pos
#		direction = (aim_position - global_position).normalized()
#		var direction: Vector2 = (Globals.cursor_pos + position).normalized()
#		shot_pistol.emit(aim_position, Globals.cursor_direction, knownDirection)
	if type == 'grenade':
		Globals.grenade_amount -= 1
		throw_grendade.emit(aim_position, direction, knownDirection)

	set_state("shoot")
	canShoot = false

func set_state(state: String):
	if state == 'walk':
		Globals.player_walking = true
	else:
		Globals.player_walking = false
	if state =="idle":
		Globals.player_idle = true
	else:
		Globals.player_idle = false
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
		pass
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
#	print('blend direction ===== ', blendDirection)
#	animationTree["parameters/aim/blend_position"] = blendDirection
#	animationTree["parameters/shoot/blend_position"] = blendDirection
	animationTree["parameters/idle/blend_position"] = blendDirection
	animationTree["parameters/walk/blend_position"] = blendDirection
	animationTree["parameters/roll/blend_position"] = blendDirection

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



func _on_cursor_area_right_body_entered(body: Node2D) -> void:
	var right :Vector2 = Vector2(1, 0)
	animationTree["parameters/aim/blend_position"] = right
	animationTree["parameters/shoot/blend_position"] = right
	print('Right : : enter : : ', body.name)



func _on_cursor_area_right_body_exited(body: Node2D) -> void:
	pass

func _on_cursor_area_left_body_entered(body: Node2D) -> void:
	var left :Vector2 = Vector2(-1, -0)
	animationTree["parameters/aim/blend_position"] = left
	animationTree["parameters/shoot/blend_position"] = left
	print('Left : : enter : : ', body.name)

func _on_cursor_area_left_body_exited(body: Node2D) -> void:
	pass

func _on_curso_area_up_body_entered(body: Node2D) -> void:
	var up :Vector2 = Vector2(0, -1)
	animationTree["parameters/aim/blend_position"] = up
	animationTree["parameters/shoot/blend_position"] = up
	print('UP : : enter : : ', body.name)
	if body is StaticBody2D:
		pass

func _on_curso_area_up_body_exited(body: Node2D) -> void:
		if body is StaticBody2D:
			pass

func _on_cursor_area_down_body_entered(body: Node2D) -> void:
	var down :Vector2 = Vector2(0, 1)
	animationTree["parameters/aim/blend_position"] = down
	animationTree["parameters/shoot/blend_position"] = down
	print('Down : : enter : : ', body.name)


func _on_cursor_area_down_body_exited(body: Node2D) -> void:
	pass









