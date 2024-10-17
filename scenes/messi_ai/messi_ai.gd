extends CharacterBody2D

# Constants
const SPEED = 500  # Horizontal movement speed
const JUMP_VELOCITY = -500.0  # Initial jump velocity
const D_VELOCITY = 950.0  # Deceleration velocity

# Variables
var push_force = 80.0  # Force applied when colliding with a ball
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")  # Get gravity from project settings
var screen_size  # Screen size for boundary checks
var ball  # Reference to the ball (Football object)

@onready var animated_sprite_2d = $AnimatedSprite2D  # Animated sprite for character visuals

# Function called when the node is ready
func _ready():
	screen_size = get_viewport_rect().size  # Get the size of the screen
	ball = $"../Football/RigidBody2D"  # Reference to the ball object

# Function to keep the character within screen bounds
func keep_in_screen_bounds():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

# Main physics loop that handles movement and collision
func _physics_process(delta):
	# Collision detection and response
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force + (velocity / 10))
			if velocity.y >= 0:
				c.get_collider().apply_central_impulse(Vector2(0, -50))
	
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("jump")

	# Keep character inside screen bounds
	keep_in_screen_bounds()

	# Handle movement and animation
	movement()

	# Handle running and idle animations
	if velocity.x > 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	
	# Apply movement and slide logic
	move_and_slide()

	# Append player state to the ghost trail for GameManager
	GameManager.messi_ghost.append([position, animated_sprite_2d.animation, animated_sprite_2d.flip_h])
	if GameManager.messi_ghost.size() > GameManager.time:
		GameManager.messi_ghost.remove_at(0)

# Function to handle character movement towards the ball
func movement():
	var distance_x = (ball.position.x + 550) - position.x  # Horizontal distance to the ball
	var distance_y = position.y - (ball.position.y + 390)  # Vertical distance to the ball
	var direction = sign(distance_x)  # Get direction towards the ball
	distance_x = abs(distance_x)  # Get absolute value of the distance
	var adjusting = false  # Flag for adjusting movement

	# Check if vertical position needs adjustment
	if distance_y >= 150 or distance_y < -100:
		adjusting = true
	else:
		jump()

	if adjusting:
		# Adjust horizontal distance if necessary
		distance_x = (ball.position.x + 550) - position.x - 150
		direction = sign(distance_x)
	
	# Set horizontal velocity
	velocity.x = direction * SPEED

# Function to handle jumping logic
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY  # Apply jump velocity if on the floor

# Function to calculate ball trajectory
func calc_trajectory():
	var ball_pos = ball.position  # Get current ball position
	var ball_vel = ball.linear_velocity  # Get current ball velocity
	var ball_future = ball_pos + ball_vel * 2  # Calculate future ball position
	return ball_future
