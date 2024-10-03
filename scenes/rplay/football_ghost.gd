extends Node2D
var index = 0

func _physics_process(delta):
	if index < GameManager.time:
		var i = round(index)
		position = GameManager.football_ghost[i][0]
		rotation = GameManager.football_ghost[i][1]
		
	index += 0.5
