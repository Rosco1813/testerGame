extends Area2D

@export var speed :int = 1000

var currentDirection: String = 'down'
var velocity = Vector2()
var direction: Vector2 = Vector2.UP
var shootDirection = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction  * speed * delta

#func _physics_process(delta):
#	print('current direction ', currentDirection)
#	if currentDirection == 'down' :
#		velocity.x = speed * delta * shootDirection
#	if currentDirection == 'up':
#		velocity.x = speed * delta * shootDirection
#	if currentDirection == 'right':
##		$AnimatedSprite2D.rotation_degrees = 90
#		velocity.y = speed * delta * shootDirection
#	if currentDirection == 'left':
##		$AnimatedSprite2D.rotation_degrees = -90
#		velocity.y = speed * delta * shootDirection


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

		
