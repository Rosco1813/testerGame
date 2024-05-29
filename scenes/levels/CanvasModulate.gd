extends CanvasModulate
const NIGHT_COLOR=Color("#091d3a")
const DAY_COLOR=Color("#ffffff")
const TIME_SCALE = 0.1
var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float)->void:
	self.time +=delta * TIME_SCALE
	self.color = NIGHT_COLOR.lerp(DAY_COLOR, abs(sin(time)))

	
