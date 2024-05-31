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


func _on_house_player_entered():
	print('house enter')
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.8,0.8), 0.8).set_trans(Tween.TRANS_QUAD)
	#use to make INVISIBLE
#	tween.tween_property($MainCharacter, "modulate:a",0,2).from(0.5)


func _on_house_player_exit():
	var tween = get_tree().create_tween()
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.6,0.6), 0.6)
