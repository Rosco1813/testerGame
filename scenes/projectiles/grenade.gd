extends RigidBody2D

@export var speed: int = 400
var direction: Vector2 = Vector2.UP
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta

func explode():
	$AnimationPlayer.play("Explosion")
#	print('EXPLODE THIS BOMB BI***')

func set_grenade_direction(knownDirection):
	if knownDirection == 'down':
#		$".".rotation_degrees = 180
		direction = Vector2.DOWN
	if knownDirection == 'up':
		pass
	if knownDirection == 'right':
#		$".".rotation_degrees = 90
		direction = Vector2.RIGHT
	if knownDirection == 'left':
#		$".".rotation_degrees = -90
		direction = Vector2.LEFT
