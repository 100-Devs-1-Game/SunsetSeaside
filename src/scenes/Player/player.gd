extends CharacterBody3D



# node declarations
@onready var head = $Head as Node3D
@onready var camera = $Head/headbob_pivot/Camera3D as Camera3D
@onready var viewmodel_camera = $Head/headbob_pivot/Camera3D/SubViewportContainer/SubViewport/viewmodel_camera
@onready var neck = $Head/headbob_pivot as Node3D

@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape

@onready var edge_detector_up = $EdgeDetectorUp

#@onready var animation_player = $Head/headbob_pivot/Camera3D/SubViewportContainer/SubViewport/viewmodel_camera/fps_rig/katana/AnimationPlayer
@onready var original_pos = global_position

# debug labels
@onready var console_ui: Control = $Head/headbob_pivot/Camera3D/console_ui

# @onready var animation_list_size = animation_player.get_animation_list().size() - 1

# movement variables

# speed vars
var speed = default_speed # the current desired speed that velocity is trying to reach
var accel = ACCEL_DEFAULT # affects how quickly velocity reaches speed (by multiplying delta in the lerp function for velocity)
var deccel = DECCEL_DEFAULT
var deccel_backpedal = DECCEL_BACKPEDAL_DEFAULT

# speed constants
##### the movement speed of each state
const default_speed = 6.0
const crouching_speed = 3.0
const sprint_speed = 11.0

const ACCEL_DEFAULT = 4.0
const DECCEL_DEFAULT = 5.0
const DECCEL_BACKPEDAL_DEFAULT = 3.0

# crouch vars
var crouch_speed = 10.0 # how fast a crouch is completed
var crouching_depth = -0.5

# jump vars / const
const JUMP_VELOCITY = 5.5

# camera variables
var mouse_sens = 1200 # divides the relation between mouse movement and camera input
var mouse_relative_x = 0
var mouse_relative_y = 0

# headbob vars
var position_last_frame = Vector3.ZERO
var foot_step_alternate = false

# landing head animation vars
@onready var original_head_pos = head.position
var landing_head_bob = 4
var verticalForce = 0.0
var verticalForceStorage = 0.0
var landing_sin_degrees = 0
var landing_buffer = 48 # decreases the length of the sin wave on both ends to make the landing animation shorter

# states
var state = Enums.PlayerState.WALKING

# get the gravity from the project settings to be synced with rigidbody nodes
var gravity = 16.0

func _ready():
	Events.shotgun_bounce.connect(_shotgun_bounce)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# setting viewmodel viewport to be the same size as the window
	$Head/headbob_pivot/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()

func _physics_process(delta):
	# setting viewmodel camera to default camera position
	viewmodel_camera.global_transform = camera.global_transform
	
	# ~~~ movement ~~~~~~~~~~~~~~~~~~
	
	# getting direction var from keyboard input
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# handle gravity and all midair checks
	if !is_on_floor():
		velocity.y -= gravity * delta
		if velocity.y < verticalForce : 		# recording the amount of vertical force to enact on the camera after falling
			verticalForce = velocity.y  		# force is based on the distance of the fall
		verticalForceStorage = verticalForce

		accel = 0.5 # changing how much control the player has over movement whislt midair
		deccel_backpedal = 0.5
	else:
		if !verticalForce == 0.0: 	 # handle landing downward head movement
			verticalForce = 0.0
		if verticalForceStorage < 0:
			var lerp = sin(deg_to_rad(landing_sin_degrees)) * verticalForceStorage  # pushes head downward one length of a sinwave, amplified by verticalForce
			head.position.y += lerp / (100 * landing_head_bob)
			if landing_sin_degrees < 181 - landing_buffer:
				landing_sin_degrees += 24
			else:
				verticalForceStorage = 0.0
				landing_sin_degrees = 0 + landing_buffer

		accel = ACCEL_DEFAULT
		deccel_backpedal = DECCEL_BACKPEDAL_DEFAULT
	
	# handle jump and wall jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

	# handle movement augmentations (crouching, sliding, sprinting)
	if Input.is_action_pressed("crouch"):
		speed = crouching_speed
		head.position.y =  lerp(head.position.y, original_head_pos.y + crouching_depth, delta * crouch_speed)
		standing_collision_shape.disabled = true; crouching_collision_shape.disabled = false
		
		state = Enums.PlayerState.CROUCHING
	elif !edge_detector_up.is_colliding():
		# handle sprinting
		if Input.is_action_pressed("sprint"):
			speed = sprint_speed
			state = Enums.PlayerState.SPRINTING
		else:
			speed = default_speed
			state = Enums.PlayerState.WALKING
		head.position.y =  lerp(head.position.y, original_head_pos.y, delta * crouch_speed)
		standing_collision_shape.disabled = false; crouching_collision_shape.disabled = true
		
	if Input.is_action_just_pressed("attack"):
		Events.fire_weapon.emit()

	# handle velocity
	if direction:	
			# velocity.x
			if velocity.x >= 0:
				if lerp(velocity.x, direction.x * speed, delta) - velocity.x < 0:
					velocity.x = lerp(velocity.x, direction.x * speed, delta * deccel_backpedal)
				else:
					velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)
			if velocity.x < 0:
				if lerp(velocity.x, direction.x * speed, delta) - velocity.x > 0:
					velocity.x = lerp(velocity.x, direction.x * speed, delta * deccel_backpedal)
				else:
					velocity.x = lerp(velocity.x, direction.x * speed, delta * accel)

			# velocity.z
			if velocity.z >= 0:
				if lerp(velocity.z, direction.z * speed, delta) - velocity.z < 0:
					velocity.z = lerp(velocity.z, direction.z * speed, delta * deccel_backpedal)
				else:
					velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
			if velocity.z < 0:
				if lerp(velocity.z, direction.z * speed, delta) - velocity.z > 0:
					velocity.z = lerp(velocity.z, direction.z * speed, delta * deccel_backpedal)
				else:
					velocity.z = lerp(velocity.z, direction.z * speed, delta * accel)
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, delta * deccel)
			velocity.z = lerp(velocity.z, 0.0, delta * deccel)
	
	if is_on_floor():
		Events.floor_reload.emit()
	
	move_and_slide()
	
	# ~~~ end of movement ~~~~~~~~~~~~~~~~~~
	
	# head bob
	neck.headbob(position_last_frame, is_on_floor(), input_dir, state, position, delta)
	
	# reset
	if Input.is_action_just_pressed("reset"):
		global_position = original_pos

	# debug labels
	console_ui.debug_label_speed.text = "speed: " + str(speed)
	console_ui.debug_label_velocity.text = "velocity: " + str(snapped(velocity.x, 0.01)) + ", " + str(snapped(velocity.z, 0.01))
	
	position_last_frame = position

func _shotgun_bounce(direction, force): # bounce the player, sent by the shotgun script
	var bounce_mod = 1.0
	if state == Enums.PlayerState.CROUCHING: bounce_mod += 0.2
	if state == Enums.PlayerState.CROUCHING && is_on_floor(): bounce_mod += 0.2
	if is_on_wall(): bounce_mod += 0.2
	console_ui.debug_label_bounce_mod.text = "last bounce mod: " + str(bounce_mod)
	velocity = velocity * 0.8
	velocity.x += direction.x * force * bounce_mod
	velocity.y += direction.y * force * bounce_mod
	velocity.z += direction.z * force * bounce_mod

func _input(event): # handling camera movement for the mouse
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouse_sens
		head.rotation.x -= event.relative.y / mouse_sens
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)
		viewmodel_camera.sway(Vector2(event.relative.x,event.relative.y))
