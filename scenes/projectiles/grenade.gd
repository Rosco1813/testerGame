extends RigidBody2D

@export var speed: int = 400
var direction: Vector2 = Vector2.UP
var explosion_active:bool = false
var explosion_radius:int = 400
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	if explosion_active:
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
#		print("explosion active")
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius
			if "hit" in target and in_range:
				target.hit()

func explode():
	$AnimationPlayer.play("Explosion")
	explosion_active = true


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
