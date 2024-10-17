extends Node2D

# Variables linked to nodes in the scene for future use.
@onready var football = $Football
@onready var label = $Label
@onready var particle_ronaldo = $Particle_Ronaldo
@onready var particle_messi = $Particle_Messi

var timer = 0  # Keeps track of time for physics-related processes

# Called when the node enters the scene for the first time.
func _ready():
	update_text()  # Update the score display when the game starts

	# Show confetti effect depending on the last player to score (Messi or Ronaldo)
	if GameManager.score_last == "messi":
		particle_messi.amount = GameManager.ball_vel  # Adjust particle amount based on ball velocity
		particle_messi.emitting = true
	elif GameManager.score_last == "ronaldo":
		particle_ronaldo.amount = GameManager.ball_vel
		particle_ronaldo.emitting = true
		# Particle emission triggers when a goal is scored based on the last scorer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Press SPACE to reset the game and clear last score
	if Input.is_action_just_pressed("SPACE"):
		GameManager.load_game_scene()  # Reload the game scene
		GameManager.score_last = ""  # Reset last score

# Physics-related updates (tracks game time in frames)
func _physics_process(_delta):
	timer += 1  # Increment the timer for future use

# Triggered when the ball enters the Ronaldo goal area (Messi scores)
func _on_ronaldo_goal_area_entered(_area):
	print("MEEESSSSIIII")  # Print message for debug purposes
	GameManager.score_messi += 1  # Increment Messi's score
	GameManager.score_last = "messi"  # Update the last scorer
	GameManager.load_replay_scene()  # Load the replay of the goal

# Triggered when the ball enters the Messi goal area (Ronaldo scores)
func _on_messi_goal_area_entered(_area):
	print("SUUIIIIII")  # Print message for debug purposes
	GameManager.load_replay_scene()  # Load replay scene after goal
	GameManager.score_ronaldo += 1  # Increment Ronaldo's score
	GameManager.score_last = "ronaldo"  # Update the last scorer
	GameManager.ball_vel = football  # Update ball velocity

# Updates the score display on the screen
func update_text():
	label.text = str(GameManager.score_messi) + " : " + str(GameManager.score_ronaldo)
	# Displays the score as "Messi's score : Ronaldo's score"
