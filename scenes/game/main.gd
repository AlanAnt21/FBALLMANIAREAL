extends Node2D
@onready var football = $Football
@onready var label = $Label
@onready var particle_ronaldo = $Particle_Ronaldo
@onready var particle_messi = $Particle_Messi

var timer = 0
var mode : String
var messi_scenes = [preload("res://scenes/messi/messi.tscn"), preload("res://scenes/messi_ai/messi_ai.tscn")]
var equal = []
var critical_kick_chance = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = GameManager.mode
	instantiate_mode(mode)
	update_text()
	if GameManager.score_last == "messi":
		particle_messi.amount = GameManager.ball_vel
		particle_messi.emitting = true
	elif GameManager.score_last == "ronaldo":
		particle_ronaldo.amount = GameManager.ball_vel
		particle_ronaldo.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if randi_range(0, 1000) == 5:
		instantiate_mode("three")
	if Input.is_action_just_pressed("SPACE"):
		GameManager.load_game_scene()
		GameManager.score_last = ""
		
func _physics_process(_delta):
	timer += 1


func _on_ronaldo_goal_area_entered(_area):
	print("MEEESSSSIIII")
	GameManager.score_messi += 1
	GameManager.score_last = "messi"
	GameManager.load_replay_scene()
	


func _on_messi_goal_area_entered(_area):
	print("SUUIIIIII")
	GameManager.load_replay_scene()
	GameManager.score_ronaldo += 1
	GameManager.score_last = "ronaldo"
	GameManager.ball_vel = football
	
func update_text():
	label.text = str(GameManager.score_messi) + " : " + str(GameManager.score_ronaldo)
	
func instantiate_mode(game_mode):
	var new_player
	if game_mode == "single":
		new_player = messi_scenes[1].instantiate()
		new_player.position = Vector2(307, 380)
	elif game_mode == "duo":
		new_player = messi_scenes[0].instantiate()
		new_player.position = Vector2(307, 438)
	elif game_mode == "three":
		var temp = []
		var random_chance = int(1/(critical_kick_chance ** 4))
		for i in range(0, random_chance):
			temp.append(random_chance)
		equal.append_array(temp)
		
	add_child(new_player)
