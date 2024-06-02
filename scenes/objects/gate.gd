extends StaticBody2D
#Custom Signals make sure root node has a script , key word 'signal', 
#then 'name_value', creates a global signal 
signal player_entered_gate(body)



func _on_area_2d_body_entered(body):
	player_entered_gate.emit(body)
	pass # Replace with function body.
