extends LevelParent




func _on_gate_player_entered_gate(_body):
	var tween = create_tween()
	var missingHealth = 100 - Globals.stamina
	tween.set_parallel(true)
	tween.tween_property($MainCharacter,"speed", 0, 0.4)
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.8,0.8), 0.8).set_trans(Tween.TRANS_QUAD)
	Globals.stamina += missingHealth
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")


func _on_house_player_entered():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.8,0.8), 0.8).set_trans(Tween.TRANS_QUAD)
	#use to make INVISIBLE
#	tween.tween_property($MainCharacter, "modulate:a",0,2).from(0.5)


func _on_house_player_exit():
	var tween = get_tree().create_tween()
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.6,0.6), 0.6)
