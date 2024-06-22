extends Sprite2D

@export var cursor_speed: float = 300.0  # Speed of cursor movement
var velocity: Vector2 = Vector2.ZERO

func _ready():
	print('cursor here')
	set_process(true)

func _process(delta):
	# Reset velocity
	velocity = Vector2.ZERO

	# Check for D-pad input
	if Input.is_action_pressed("aim"):
		if Input.is_action_pressed("left"):
			velocity.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += 1
		if Input.is_action_pressed("up"):
			velocity.y -= 1
		if Input.is_action_pressed("down"):
			velocity.y += 1

	# Normalize to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * cursor_speed

	# Move the cursor
	position += velocity * delta

	# Clamp the cursor to the screen bounds (optional)
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	position.y = clamp(position.y, 0, get_viewport_rect().size.y)

