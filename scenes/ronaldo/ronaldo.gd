extends CharacterBody2D

# Define the force applied to objects when the player collides with them
var push_force = 80.0

# Reference to the player's animated sprite for handling animations
@onready var animated_sprite_2d = $AnimatedSprite2D

# Constants for movement and jump
const SPEED = 500.0  # Movement speed
const JUMP_VELOCITY = -500.0  # Upward velocity when jumping
const D_VELOCITY = 950.0  # Downward velocity when "down" input is pressed mid-air

# Get the gravity from project settings for consistency with other physics objects
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Variable to store screen size for boundary checking
var screen_size

# Called when the node is added to the scene
func _ready():
	screen_size = get_viewport_rect().size  # Get the screen size to clamp the player's position within the boundaries

# Ensure the player stays within the game screen boundaries
func keep_in_screen_bounds():
	position.x = clamp(position.x, 0, screen_size.x)  # Clamp player's x position within screen width
	position.y = clamp(position.y, 0, screen_size.y)  # Clamp player's y position within screen height

# Physics process function, called every frame to handle movement and collisions
func _physics_process(delta):
	# Handle collisions and apply force to objects like the ball
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:  # Check if the collider is a RigidBody2D (e.g., a ball)
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force + (velocity / 10))  # Push object based on collision
			if velocity.y >= 0:
				c.get_collider().apply_central_impulse(Vector2(0, -50))  # Add upward impulse if falling

	# Apply gravity to the player if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta  # Add gravity to the y-velocity
		animated_sprite_2d.play("jump")  # Play jump animation if the player is in the air

	# Handle jumping when the "ui_accept" input (default is spacebar) is pressed
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Apply jump force when on the floor
	
	# Handle downward movement when the "ui_down" input is pressed while in the air
	if Input.is_action_just_pressed("ui_down") and not is_on_floor():
		velocity.y = D_VELOCITY  # Apply downward force when falling

	# Handle left-right movement input
	var direction = Input.get_axis("ui_left", "ui_right")  # Get the direction input (-1 for left, 1 for right)
	velocity.x = move_toward(velocity.x, 0, SPEED)  # Decelerate the player when no input is given
	velocity.x = direction * SPEED  # Set horizontal velocity based on input direction

	# Play the appropriate animation based on movement
	if velocity.x > 0:
		animated_sprite_2d.play("run")  # Play run animation when moving right
		animated_sprite_2d.flip_h = false  # Ensure the sprite faces right
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true  # Flip the sprite when moving left
		animated_sprite_2d.play("run")  # Play run animation when moving left
	else:
		animated_sprite_2d.play("idle")  # Play idle animation when not moving

	# Move the player and handle sliding
	move_and_slide()

	# Record the player's position, animation, and sprite flip state for a "ghost" replay
	GameManager.ronaldo_ghost.append([position, animated_sprite_2d.animation, animated_sprite_2d.flip_h])

	# Remove the oldest ghost data if the list exceeds the replay time limit
	if GameManager.ronaldo_ghost.size() > GameManager.time:
		GameManager.ronaldo_ghost.remove_at(0)
