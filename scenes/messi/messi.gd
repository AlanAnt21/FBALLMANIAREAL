extends CharacterBody2D

var push_force = 80.0  # Force applied when colliding with rigid bodies (e.g., the ball)
@onready var animated_sprite_2d = $AnimatedSprite2D  # Reference to the player's sprite for animation

const SPEED = 500.0  # Movement speed for left and right
const JUMP_VELOCITY = -500.0  # Jump force (upwards velocity)
const D_VELOCITY = 950.0  # Downward velocity when "S" is pressed

# Get gravity from project settings to synchronize with other physics objects
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var screen_size  # Variable to store the screen size

# Called when the node is added to the scene
func _ready():
	screen_size = get_viewport_rect().size  # Get the screen size to restrict movement within bounds
	position.x = 0  # Set the initial x-position of the player

# Keep the player within the screen bounds by clamping position
func keep_in_screen_bounds():
	position.x = clamp(position.x, 0, screen_size.x)  # Clamp x-position to screen width
	position.y = clamp(position.y, 0, screen_size.y)  # Clamp y-position to screen height
	# Ensures the player stays within the game window

# Called every frame to process physics-related updates
func _physics_process(delta):
	# Check for collisions and apply push force if colliding with a RigidBody2D (e.g., ball)
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force + (velocity / 10))  # Push the ball on collision
			if velocity.y >= 0:
				c.get_collider().apply_central_impulse(Vector2(0, -50))  # Apply upward impulse if falling
				# This block handles collision response with the ball (a RigidBody2D object)

	# Apply gravity to the player if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta  # Add gravity to y-velocity
		animated_sprite_2d.play("jump")  # Play jump animation if in the air

	# Handle jumping when "W" is pressed, but only when on the floor
	if Input.is_action_just_pressed("w_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Apply jump force when "W" is pressed

	# Handle fast falling when "S" is pressed and player is in the air
	if Input.is_action_just_pressed("s_down") and not is_on_floor():
		velocity.y = D_VELOCITY  # Apply downward force when "S" is pressed

	# Handle left and right movement using "A" and "D"
	var direction = Input.get_axis("a_left", "d_right")  # Get movement direction (left or right)
	velocity.x = move_toward(velocity.x, 0, SPEED)  # Move towards 0 velocity (decelerate)
	velocity.x = direction * SPEED  # Apply movement speed in the chosen direction

	# Play the appropriate animation based on movement direction
	if velocity.x > 0:
		animated_sprite_2d.play("run")  # Play run animation when moving right
		animated_sprite_2d.flip_h = false  # Ensure the sprite faces right
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true  # Flip sprite when moving left
		animated_sprite_2d.play("run")  # Play run animation
	else:
		animated_sprite_2d.play("idle")  # Play idle animation when not moving

	# Move the player and handle collisions
	move_and_slide()

	# Flip the player's image depending on the movement direction
	# Left = flip horizontally, right = no flip

	#GameManager.messi_ghost.append([position, animated_sprite_2d.animation, animated_sprite_2d.flip_h])
	#if GameManager.messi_ghost.size() > GameManager.time:
		#GameManager.messi_ghost.remove_at(0)
