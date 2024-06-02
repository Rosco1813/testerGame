extends StaticBody2D
class_name itemsParent

@onready var currentDirection: Vector2 = Vector2.DOWN.rotated(rotation)

var opened:bool = false

signal open(pos, direction)



