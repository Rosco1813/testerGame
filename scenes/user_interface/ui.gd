extends CanvasLayer


var green: Color = Color("78c52d")
var red: Color = Color(0.9,0,0,1)
var oragnge: Color = Color("f8b64f")
var violet: Color = Color("4565be")

#signal cursor_location_ui(pos, direction)

@onready var laser_label: Label = $LaserCounter/VBoxContainer/Label
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
@onready var laser_icon:TextureRect = $LaserCounter/VBoxContainer/TextureRect
@onready var grenade_icon:TextureRect = $GrenadeCounter/VBoxContainer/TextureRect
@onready var health_bar:TextureProgressBar = $HealthContainer/TextureProgressBar
@onready var stamina_bar:ProgressBar = $StaminaContainer/ProgressBar

func _ready():
	Globals.connect("stat_change", update_stat_text)
	update_laser_text()
	update_grenade_text()
	update_health_text()


func update_color(amount:int, num_to_check:float, label:Label, icon:TextureRect) ->void:
	var percentage = (num_to_check / amount ) * 100

	label.text = str(num_to_check)
	icon.modulate = violet

	if percentage > 66:
		label.modulate = green

	elif percentage > 33:
		label.modulate = oragnge

	else:
		label.modulate = red

func update_laser_text():
	update_color(6, Globals.laser_amount, laser_label, laser_icon)

func update_grenade_text():
	update_color(3, Globals.grenade_amount, grenade_label, grenade_icon)

func update_health_text():
#	print('update health text : ', Globals.health)
	health_bar.value = Globals.health

func update_stamina_text():
	stamina_bar.value = Globals.stamina

func update_stat_text():
	update_laser_text()
	update_grenade_text()
	update_health_text()
	update_stamina_text()
#	update_shotgun_text()

#func update_shotgun_text():
#	update_color(3, Globals.grenade_amount, shotgun_label, shotgun_icon)
#


func _on_cursor_cursor_location(_pos, _direction) -> void:
	pass
#	Globals.cursor_pos = pos
#	cursor_location_ui.emit(pos, direction)
