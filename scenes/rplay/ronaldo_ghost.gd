extends Node2D
var index = 0
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.speed_scale = 0.5

func _physics_process(delta):
	if index < GameManager.ronaldo_ghost.size():
		var i = int(index)
		position = GameManager.ronaldo_ghost[i][0]
		animated_sprite_2d.animation = GameManager.ronaldo_ghost[i][1]
		animated_sprite_2d.flip_h = GameManager.ronaldo_ghost[i][2]
	else:
		GameManager.load_game_scene()
		
	index += 0.5
