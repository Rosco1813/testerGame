extends CanvasModulate
const NIGHT_COLOR=Color("#091d3a")
const DAY_COLOR=Color("#ffffff")
const TIME_SCALE = 0.02
var time = 0


func _process(delta:float)->void:
	self.time +=delta * TIME_SCALE
	self.color = DAY_COLOR.lerp(NIGHT_COLOR, abs(sin(time)))

	
