extends CharacterBody2D

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

signal shot_pistol(position, direction, knownDirection)
signal throw_grendade(position, direction)

var direction: Vector2 = Vector2.ZERO
var knownDirection = 'down';
@export var max_speed:int = 500
var speed:int = max_speed

var aim: bool = false
var shoot: bool = false
var canShoot:bool = true

var grenade:bool = false

var ammoPrimary: int = 7
var grenades:int = 4

var roll:bool = false
var walk:bool = false
var idle:bool = false

var right:bool = false
var left:bool = false
var up:bool = false
var down:bool = true

var current_direction


# Called when the node enters the scene tree for the first time.
func _ready():
	print('test')
	set_walking(false)
	set_idle(true)


func _physics_process(_delta):
	if !aim and !shoot:
		velocity = direction * speed
		move_and_slide()

	else:
		velocity = Vector2.ZERO
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var laser_markers = $LaserStartPositions.get_children()
	var selected_laser
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction != Vector2.ZERO:
		update_blend_position(direction)
		if not aim and not shoot:
			set_walking(true)
			set_idle(false)
	else:
		set_idle(true)
		set_walking(false)
		set_aim(false)
		set_roll(false)
		set_shoot(false)
	
	if Input.is_action_pressed('aim'):
		set_aim(true)
		set_walking(false)
		set_idle(false)
		set_roll(false);

	


	if Input.is_action_just_pressed("attack") and aim:
		velocity = Vector2.ZERO
		ammoPrimary= use_weapon(ammoPrimary, 'pistol')
		print( " : direction : ", direction)
		
		if direction.y == 1:
			selected_laser = laser_markers[3]
			if canShoot:
				$gunPartilcesDown.emitting = true
				knownDirection = 'down';
				shot_pistol.emit(selected_laser.global_position, direction, knownDirection)
				set_shoot(true)
				
		if direction.y == -1:
			selected_laser = laser_markers[1]
			if canShoot:
				$gunPartilcesUp.emitting = true
				knownDirection = 'up';
				shot_pistol.emit(selected_laser.global_position, direction, knownDirection)
				set_shoot(true)
				
		if direction.x == 1:
			selected_laser = laser_markers[0]
			if canShoot:
				$gunPartilcesRight.emitting = true
				knownDirection = 'right';
				shot_pistol.emit(selected_laser.global_position, direction, knownDirection)
				set_shoot(true)
		if direction.x == -1:
			selected_laser = laser_markers[2]
			if canShoot:
				$gunPartilcesLeft.emitting = true
				knownDirection = 'left';
				shot_pistol.emit(selected_laser.global_position, direction, knownDirection)
				set_shoot(true)

		
#		if ammoPrimary != 0:
		#emit the position se selected
		set_walking(false)
		set_idle(false)
		if canShoot:
#			set_shoot(true)
			canShoot = false
#			shot_pistol.emit(selected_laser.global_position, direction, knownDirection)
			$pistolTimer.start()
			
	if Input.is_action_just_pressed("roll") and direction:
		speed = 800
		set_shoot(false)
		set_roll(true)

	
	if Input.is_action_just_pressed("secondary action"):
		grenades = use_weapon(grenades, 'grenade')

		velocity = Vector2.ZERO
		laser_markers = $LaserStartPositions.get_children()
		var selected_grenade

		if down:
			selected_grenade = laser_markers[3]
			knownDirection = 'down';

		if up:
			selected_grenade = laser_markers[1]
			knownDirection = 'up';
			
		if right:
			selected_grenade = laser_markers[0]
			knownDirection = 'right';

		if left:
			selected_grenade = laser_markers[2]
			knownDirection = 'left';
#		if grenades  != 0:
		throw_grendade.emit(selected_grenade.global_position, direction, knownDirection)
		


func set_shoot(value = false):
	shoot = value
	animationTree["parameters/conditions/is_shooting"] = value
	

func set_roll(value = false):
	roll = value
	animationTree["parameters/conditions/is_rolling"] = value

func set_aim(value = false):
	aim = value
	animationTree["parameters/conditions/is_shooting"] = not value
	animationTree["parameters/conditions/is_aiming"] = value

func set_walking(value = false):
	walk = value
	animationTree["parameters/conditions/is_walking"] = value
	animationTree["parameters/conditions/is_rolling"] = not value
	
func set_idle(value):
	idle = value
	animationTree["parameters/conditions/is_idle"] =  value
	
func use_weapon(ammo, ammoType):
#	print('Ammo left : ', ammo, ' type : ', ammoType)
	if ammo > 0:
		return ammo -1
	else:
		if ammoType == 'pistol':
			$pistolTimer.start()
		elif ammoType == 'grenade':
			$grenadeTimer.start()
		return ammo
		
func set_direction(value):
	right = value
	left = value
	up = value
	down = value

func _on_pistol_timer_timeout():
	ammoPrimary = 7
	canShoot = true


func _on_grenade_timer_timeout():
	grenades = 4


func update_blend_position(blendDirection):
	if not Input.is_action_pressed("aim"):
		set_aim(false)
		set_shoot(false)
	if not Input.is_action_pressed("roll"):
		set_roll(false)
	if Input.is_action_just_pressed("down"):
		
		down = true
		up = false
		right = false
		left = false
	if Input.is_action_just_pressed("up"):
		up = true
		down = false
		right = false
		left = false
	if Input.is_action_just_pressed("right"):
		right = true
		down = false
		up = false
		left = false
	if Input.is_action_just_pressed("left"):
		left = true
		down = false
		up = false
		right = false
	animationTree["parameters/shoot/blend_position"] = blendDirection
	animationTree["parameters/idle/blend_position"] = blendDirection
	animationTree["parameters/walk/blend_position"] = blendDirection
	animationTree["parameters/roll/blend_position"] = blendDirection
	animationTree["parameters/aim/blend_position"] = blendDirection



func stop_animation(blendDirection):
	animationTree["parameters/idle/blend_position"] = blendDirection



func _on_animation_tree_animation_finished(anim_name):
	
		var rolling = ['roll_down_2','roll_up_2','roll_left_2','roll_right_2']
		for roll in rolling:
			if roll == anim_name:
				canShoot = true
				speed = max_speed
				
#	print('Animation finished : ', anim_name)



func _on_animation_tree_animation_started(anim_name):
	var rolling = ['roll_down_2','roll_up_2','roll_left_2','roll_right_2']
	for roll in rolling:
		if roll == anim_name:
			canShoot = false
			
				
	




