extends Node2D
var index = 0

func _physics_process(delta):
	position = GameManager.ronaldo_ghost[index]
		
	index += 1
