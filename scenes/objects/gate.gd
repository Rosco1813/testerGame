extends StaticBody2D
#Custom Signals make sure root node has a script , key word 'signal', 
#then 'name_value', creates a global signal 
signal player_entered_gate(body)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	player_entered_gate.emit(body)
	pass # Replace with function body.
