extends itemsParent


var hitCount:int = 0;

func hit():
	hitCount = hitCount + 1
	print('BOX HIT', hitCount)
