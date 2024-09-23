extends Node2D
@onready var football = $Football
@onready var label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("SPACE"):
		GameManager.load_game_scene()


func _on_ronaldo_goal_area_entered(_area):
	print("MEEESSSSIIII")
	GameManager.load_game_scene()
	GameManager.score_messi += 1
	


func _on_messi_goal_area_entered(_area):
	print("SUUIIIIII")
	GameManager.load_game_scene()
	GameManager.score_ronaldo += 1
	
func update_text():
	label.text = "Score: " + str(GameManager.score_messi) + " : " + str(GameManager.score_ronaldo)

