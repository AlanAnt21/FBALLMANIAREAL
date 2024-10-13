extends CharacterBody2D
var push_force = 80.0
@onready var animated_sprite_2d = $AnimatedSprite2D
const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const D_VELOCITY = 950.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var screen_size
var ball

func _ready():
	screen_size = get_viewport_rect().size
	ball = $"../Football/RigidBody2D"

func keep_in_screen_bounds():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(delta):
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force + (velocity/10))
			if velocity.y >= 0:
				c.get_collider().apply_central_impulse(Vector2(0, -50))
	# Add the gravity.
	keep_in_screen_bounds()
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("jump")

	# Handle jump.
	movement()
	#jump()
	# var direction_y = Input.get_axis()
	#var distance = (ball.position.x + 550) - position.x
	#print(ball.position.x)
	#var direction = sign(distance)
	#distance = abs(distance)
	
	#velocity.x = direction * SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction_x = Input.get_axis("a_left", "d_right")
	#velocity.x = move_toward(velocity.x, 0, SPEED)
	#velocity.x = direction_x * SPEED
	if velocity.x > 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	move_and_slide()
	
	GameManager.messi_ghost.append([position, animated_sprite_2d.animation, animated_sprite_2d.flip_h])
	if GameManager.messi_ghost.size() > GameManager.time:
		GameManager.messi_ghost.remove_at(0)
		
func movement():
	var distance_x = (ball.position.x + 550) - position.x
	var distance_y = position.y - (ball.position.y + 390)
	var direction = sign(distance_x)
	distance_x = abs(distance_x)
	var adjusting = false
	
	if distance_y >= 150 or distance_y < -100:
		adjusting = true
	else:
		jump()
		
	if adjusting:
		distance_x = (ball.position.x + 550) - position.x - 150
		if distance_x > 20 and direction <= 0:
			direction = sign(distance_x)
		else:
			direction = 0
		
			
		
	
	velocity.x = direction * SPEED
		
	
func jump():
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
			
func calc_trajectory():
	var ball_pos = ball.position
	var ball_vel = ball.linear_velocity
	
	var ball_future = ball_pos + ball_vel * 2
	
	return ball_future
