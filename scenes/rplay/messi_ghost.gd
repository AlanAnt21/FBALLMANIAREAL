extends Node2D
var index = 0
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	animated_sprite_2d.speed_scale = 0.5

func _physics_process(delta):
	if index < GameManager.time:
		var i = int(index)
		position = GameManager.messi_ghost[i][0]
		animated_sprite_2d.animation = GameManager.messi_ghost[i][1]
		animated_sprite_2d.flip_h = GameManager.messi_ghost[i][2]
		
		
	index += 0.5
