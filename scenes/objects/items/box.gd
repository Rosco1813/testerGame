extends itemsParent


var hitCount:int = 0;

func hit():
	hitCount = hitCount + 1
	if not opened and hitCount > 1:
		var pos = $SpanPositions/Marker2D.global_position
		open.emit(pos, currentDirection)
		queue_free()

