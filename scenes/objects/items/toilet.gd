extends itemsParent


func hit():
	$AudioStreamPlayer2D.play()
	if not opened:
		$LidSprite.hide()
		var pos = $SpanPositions/Marker2D.global_position
		open.emit(pos, currentDirection)
		opened = true
