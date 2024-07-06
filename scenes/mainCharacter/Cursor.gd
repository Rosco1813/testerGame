extends StaticBody2D


#extends Sprite2D

@onready var cursor = $"."
@onready var cursor_boundary = $"../CursorBoundary"
@onready var collision_shape  =$"../CursorBoundary/CollisionShape2D"
@export var cursor_speed: float = 3000.0  # Speed of cursor movement
var velocity: Vector2 = Vector2.ZERO


func _ready():
	set_process(true)

func _process(delta):
	# Reset velocity
	velocity = Vector2.ZERO
	Globals.cursor_pos = global_position
	# Check for D-pad input
#	if Input.is_action_pressed("aim"):
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1


	if Globals.player_walking == true or Globals.player_idle == true:
		cursor_speed = 0
		cursor.hide()
	else:
		cursor.show()
		cursor_speed = 3000
#
#	# Normalize to prevent faster diagonal movement
	if velocity.length() > 0:
		velocity = velocity.normalized() * cursor_speed

	cursor.position += velocity * delta








