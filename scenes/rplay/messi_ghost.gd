extends Node2D
var index = 0

func _physics_process(delta):
	position = GameManager.messi_ghost[index]
		
	index += 1
