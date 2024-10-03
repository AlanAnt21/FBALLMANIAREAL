extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	GameManager.football_ghost.append([position + Vector2(550, 390), rotation, linear_velocity])
	if GameManager.football_ghost.size() > GameManager.time:
		GameManager.football_ghost.remove_at(0)