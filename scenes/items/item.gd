extends Area2D

var rotation_speed:int =4
var available_options = ['laser','grenade','health']
var type = available_options[randi()%len(available_options)]


func _ready():
	if type == 'laser':
		$Sprite2D.modulate = Color(0.1,0.2,0.8)
	if type =='grenade':
		$Sprite2D.modulate= Color(0.8,0.2,0.1)
	if type == 'health':
		$Sprite2D.modulate= Color(0.1,0.8,0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rotation_speed * delta
	



func _on_body_entered(_body):
#	body.add_item(type)
	if type == 'health':
		Globals.health += 10
	if type == 'laser':
		Globals.laser_amount += 4
	if type == 'grenade':
		Globals.grenade_amount +=2
	queue_free()
