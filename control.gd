extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	GameManager.mode = "single"
	GameManager.load_game_scene()
	


func _on_button_2_pressed():
	GameManager.mode = "duo"
	GameManager.load_game_scene()
