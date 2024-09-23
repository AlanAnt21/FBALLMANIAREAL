extends CharacterBody2D
var push_force = 80.0
@onready var animated_sprite_2d = $AnimatedSprite2D
const SPEED = 500.0
const JUMP_VELOCITY = -500.0
const D_VELOCITY = 950.0
const DOUBLETAP_DELAY = .01
var doubletap_time = DOUBLETAP_DELAY
var last_keycode = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func keep_in_screen_bounds():
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(delta):
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force+ (velocity/10))
			c.get_collider().apply_central_impulse(Vector2(0, -50))
	# Add the gravity.
	keep_in_screen_bounds()
	if not is_on_floor():
		velocity.y += gravity * delta
		animated_sprite_2d.play("jump")

	# Handle jump.
	if Input.is_action_just_pressed("w_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("s_down") and not is_on_floor():
		velocity.y = D_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("a_left", "d_right")
	velocity.x = move_toward(velocity.x, 0, SPEED)
	velocity.x = direction * SPEED
	if velocity.x > 0:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = false
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	move_and_slide()


func _process(delta):
	doubletap_time -= delta
	
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if last_keycode == event.keycode and doubletap_time >= 0:
			if velocity.x < 0:
				velocity.x -= 1000
				print("left")
			if velocity.x > 0:
				velocity.x += 1000
			last_keycode = 0
		else:
			last_keycode = event.keycode
		doubletap_time = DOUBLETAP_DELAY
		move_and_slide()

func _on_messi_goal_area_entered(area):
	pass # Replace with function body.
