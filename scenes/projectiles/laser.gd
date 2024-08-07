extends Area2D

@export var speed :int = 1000

var currentDirection: String = 'down'
var velocity = Vector2()
var direction: Vector2 = Vector2.UP
var shootDirection = 1

func _ready():
	$lazerTimeLimit.start()
#	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction  * speed * delta
#	print('Lazer position : : ', direction)

func set_lazer_direction(knownDirection):
	currentDirection = knownDirection
	if knownDirection == 'down':
		$".".rotation_degrees = 180
		direction = Vector2.DOWN
	if knownDirection == 'up':
		$".".rotation_degrees = 0
		direction = Vector2.UP
	if knownDirection == 'right':
		$".".rotation_degrees = 90
		direction = Vector2.RIGHT
	if knownDirection == 'left':
		$".".rotation_degrees = -90
		direction = Vector2.LEFT


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	queue_free()

func _on_lazer_time_limit_timeout():
	queue_free()
