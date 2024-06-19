extends Area2D

var rotation_speed:int =4

#var ammo_image = "res://graphics/items/Revolver_Ammo.png"
var item_texture:Texture

var direction : Vector2
var distance: int = randi_range(150, 250)

var available_options = ['laser','grenade','health', 'shotgun', 'small_health', 'files', 'shotgun_ammo']
var type = available_options[randi()%len(available_options)]
func _ready():
	var target_pos = position + direction * distance
	var tween = create_tween()
	if type == 'laser':
		item_texture = load("res://graphics/items/Revolver_Ammo.png")
		$Sprite2D. texture = item_texture
	if type =='grenade':
		$Sprite2D.modulate= Color(0.8,0.2,0.1)
	if type == 'health':
		item_texture = load("res://graphics/items/Full_Health_Front.png")
		$Sprite2D. texture = item_texture
	if type == 'shotgun':
		item_texture = load("res://graphics/items/Shotgun.png")
		$Sprite2D. texture = item_texture
	if type == 'small_health':
		item_texture = load("res://graphics/items/Small_Health_Front.png")
		$Sprite2D. texture = item_texture
	if type == 'files':
		item_texture = load("res://graphics/items/Files.png")
		$Sprite2D. texture = item_texture
	if type == 'shotgun_ammo':
		item_texture = load("res://graphics/items/Shotgun_Ammo.png")
		$Sprite2D. texture = item_texture

	tween.set_parallel(true)
	tween.tween_property(self, 'position', target_pos, 0.5)
	tween.tween_property(self, 'scale', Vector2(1,1), 0.3).from(Vector2(0,0))

func _process(delta):
#	rotation += rotation_speed * delta
	pass

func _on_body_entered(_body):
	if type == 'health':
		Globals.health += 10
	if type == 'laser':
		Globals.laser_amount += 4
	if type == 'grenade':
		Globals.grenade_amount +=2
	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
