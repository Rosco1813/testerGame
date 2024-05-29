extends LevelParent


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_gate_player_entered_gate(_body):
	print('GATE ENTERED')
	var tween = create_tween()
	tween.tween_property($MainCharacter,"speed", 0, 0.4)
