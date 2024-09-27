extends Node2D
@onready var football = $Football
@onready var label = $Label
@onready var particle_ronaldo = $Particle_Ronaldo
@onready var particle_messi = $Particle_Messi


# Called when the node enters the scene tree for the first time.
func _ready():
	update_text()
	if GameManager.score_last == "messi":
		particle_messi.emitting = true
	elif GameManager.score_last == "ronaldo":
		particle_ronaldo.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("SPACE"):
		GameManager.load_game_scene()
		GameManager.score_last = ""


func _on_ronaldo_goal_area_entered(_area):
	print("MEEESSSSIIII")
	GameManager.load_game_scene()
	GameManager.score_messi += 1
	GameManager.score_last = "messi"
	


func _on_messi_goal_area_entered(_area):
	print("SUUIIIIII")
	GameManager.load_game_scene()
	GameManager.score_ronaldo += 1
	GameManager.score_last = "ronaldo"
	
func update_text():
	label.text = "Score: " + str(GameManager.score_messi) + " : " + str(GameManager.score_ronaldo)
