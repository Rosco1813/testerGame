extends itemsParent


func hit():
	$AudioStreamPlayer2D.play()
	if not opened:
		$LidSprite.hide()
		var pos = $SpanPositions.get_child(randi()%$SpanPositions.get_child_count()).global_position
		for i in range(5):
			open.emit(pos, currentDirection)
		opened = true
