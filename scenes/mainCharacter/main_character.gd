extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed = 400

var aim: bool = false
var shoot: bool = false
var grenade:bool = false

var ammoPrimary: int = 6
var grenades:int = 3


var roll:bool = false
var walk:bool = false
var idle:bool = false


@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_walking(false)
	set_idle(true)
#	screen_size = get_viewport_rect().size
#	animationTree.active = true


func _physics_process(delta):
	if  not aim and not shoot:
		velocity = direction * speed
#		print('Velocity : ', velocity)
#		print('Direction : ', direction)
#		position = position.clamp(Vector2.ZERO, screen_size)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction != Vector2.ZERO:
		update_blend_position(direction)
		if not aim:
			set_walking(true)
			set_idle(false)
	else:
		set_idle(true)
		set_walking(false)
		set_aim(false)
		set_roll(false)
		set_shoot(false)
	
	if Input.is_action_pressed('aim'):
		velocity = Vector2.ZERO
		set_aim(true)
		set_walking(false)
		set_idle(false)

	if Input.is_action_just_pressed("attack") and aim:
		
		velocity = Vector2.ZERO
		ammoPrimary= use_weapon(ammoPrimary, 'pistol')
		
#		print('shot - ammo : ', ammoPrimary)
		set_shoot(true)
		set_idle(false)
	
	if Input.is_action_just_pressed("roll") and direction:
		set_roll(true)
	
	if Input.is_action_just_pressed("secondary action"):
		grenades = use_weapon(grenades, 'grenade')
		print('shoot grenade')

func set_shoot(value = false):
	shoot = value
	animationTree["parameters/conditions/is_shooting"] = value

func set_roll(value = false):
	speed = 400
	roll = value
	animationTree["parameters/conditions/is_rolling"] = value

func set_aim(value = false):
	aim = value
	animationTree["parameters/conditions/is_shooting"] = not value
	animationTree["parameters/conditions/is_aiming"] = value

func set_walking(value = false):
	walk = value
	animationTree["parameters/conditions/is_walking"] = value
	
func set_idle(value):
	idle = value
	animationTree["parameters/conditions/is_idle"] =  value
	
func use_weapon(ammo, ammoType):
	print('Ammo left : ', ammo, ' type : ', ammoType)
	if ammo > 0:
		return ammo -1
	else:
		if ammoType == 'pistol':
			$pistolTimer.start()
		elif ammoType == 'grenade':
			$grenadeTimer.start()
		return ammo

	
	

func update_blend_position(direction):
	animationTree["parameters/shoot/blend_position"] = direction
	animationTree["parameters/idle/blend_position"] = direction
	animationTree["parameters/walk/blend_position"] = direction
	animationTree["parameters/roll/blend_position"] = direction
	animationTree["parameters/aim/blend_position"] = direction
	



func _on_pistol_timer_timeout():
	ammoPrimary = 6
	print('Pistol reloded : ', ammoPrimary)



func _on_grenade_timer_timeout():
	grenades = 3
	print('Grenade reloded : ', grenades)
