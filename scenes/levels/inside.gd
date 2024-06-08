extends LevelParent



func _on_exit_gate_area_body_entered(_body):
	var tween = get_tree().create_tween()
	tween.tween_property($MainCharacter,"speed", 0, 0.4)
	var missingHealth = 100 - Globals.stamina
	Globals.stamina += missingHealth
	TransitionLayer.change_scene("res://scenes/levels/outside_level.tscn")
	
func _on_enter_area_body_exited(_body):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($MainCharacter/Camera2D, "zoom", Vector2(0.8,0.8), 0.8).set_trans(Tween.TRANS_QUAD)
	
