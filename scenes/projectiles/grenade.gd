extends RigidBody2D

@export var speed: int = 400
var direction: Vector2 = Vector2.UP
var explosion_active:bool = false
var explosion_radius:int = 400

func _process(delta):
	position += direction * speed * delta

	if explosion_active:
		speed = 0

		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
		for target in targets:
			print('grendade target : ', target)
			var in_range = target.global_position.distance_to(global_position) < explosion_radius
			if "hit" in target and in_range:
				target.hit()

func explode():
	$AnimationPlayer.play("Explosion")
	explosion_active = true

func set_grenade_direction(knownDirection):
	if knownDirection == 'down':
		direction = Vector2.DOWN
	if knownDirection == 'up':
		pass
	if knownDirection == 'right':
		direction = Vector2.RIGHT
	if knownDirection == 'left':
		direction = Vector2.LEFT





func _on_body_entered(body: Node) -> void:
	print('grenade hit body ', body)
