extends Area2D

@export var speed :int = 1000

var currentDirection: String = 'down'
var velocity = Vector2()
var direction: Vector2 = Vector2.UP
var shootDirection = 1

func _ready():
	$lazerTimeLimit.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction  * speed * delta





func set_lazer_direction(knownDirection): 
#	print('LAZER LAXER ', knownDirection)
	currentDirection = knownDirection
	if knownDirection == 'down':
		$".".rotation_degrees = 180
		direction = Vector2.DOWN
	if knownDirection == 'up':
		pass
	if knownDirection == 'right':
		$".".rotation_degrees = 90
		direction = Vector2.RIGHT
	if knownDirection == 'left':
		$".".rotation_degrees = -90
		direction = Vector2.LEFT

		


func _on_body_entered(body):
	print('body : ', body)
	if "hit" in body:
		print('hit object')
		body.hit()
		queue_free()
	



func _on_lazer_time_limit_timeout():
#	print('lazer time up')
	queue_free()
