extends CharacterBody3D
# responsible for player movement, input, and some ui

# movement and airstrafing made in part with implementations by AceSpectre, cheers
# https://www.youtube.com/watch?v=id-odmTZ_H4&t=157s 
# https://github.com/AceSpectre/Quakelike-Controller

# node declarations
@onready var head = $Head as Node3D
@onready var camera = $Head/headbob_pivot/Camera3D as Camera3D
@onready var viewmodel_camera = $Head/headbob_pivot/Camera3D/SubViewportContainer/SubViewport/viewmodel_camera
@onready var neck = $Head/headbob_pivot as Node3D

@onready var standing_collision_shape = $standing_collision_shape
@onready var crouching_collision_shape = $crouching_collision_shape

@onready var explosion_trail_spawner: Node3D = $explosion_trail_spawner

@export var console_ui: Control
@onready var original_pos = global_position

# @onready var animation_list_size = animation_player.get_animation_list().size() - 1

const speeds = {
	"walk" : 6.0,
	"crouch" : 3.0,
	"sprint" : 11.0,
	"air" : 15.0 
	}
const accels = {
	"floor" : 7.0,
	"crouch" : 4.0,
	"air" : 0.3
	} 
const drags = {
	"floor" : 8.0,
	"crouch" : 4.0,
	"air" : 0.01
	}
const gravity = 16.0

# crouch vars
var crouch_headspeed = 10.0 # how fast a crouch is completed
var crouch_height_difference = 0.7 # difference in height between shapes
var crouch_jump_offset = -0.1 # the offset of height change when crouch jumping
#var crouch_toggle = false

# jump vars / const
const jump_velocity = 8.5

# airstrafing
@export var air_strafe_curve : Curve
var strafe_angle_min = 0.0
var strafe_angle_max = 180.0
var air_strafe_modifier = 2.5 # multiplies the curve value

### camera variables
var mouse_sense = 0.4 # divides the relation between mouse movement and camera input
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
var crouching_last_frame = false

# reminder: type safety is for pussies
func _ready():
	set_meta(&"Player", self) # for recognition of body type by areas
	Gamestate.player = self
	
	# setting viewmodel viewport to be the same size as the window
	$Head/headbob_pivot/Camera3D/SubViewportContainer/SubViewport.size = DisplayServer.window_get_size()

	_establish_events()
	_establish_settings()


func _physics_process(delta):
	# setting viewmodel camera to default camera position
	viewmodel_camera.global_transform = camera.global_transform
	
	# state -> movement
	_input_calc()
	_handle_crouch(delta)
	_handle_landing_cam()
	_move(delta)
	
	if is_on_floor(): Events.floor_reload.emit()
	elif is_on_wall(): Events.wall_reload.emit()
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down") # keeping for headbob script
	#if input_dir != Vector2.ZERO: _first_input_check()
	neck.headbob(position_last_frame, is_on_floor(), input_dir, state, position, delta)
	position_last_frame = position
	Gamestate.player_global_position = global_position
	
	# debug
	if global_position.y < -10.0: # below map failsafe
		Events.player_death.emit(Enums.PlayerDeathType.INSTANT)

	if Input.is_action_just_pressed("reset"):
		global_position = original_pos

	_debug_label_update()
	
### physics functions
func _move(delta):
	# assign movement values based on state
	var move_vals = _get_movestate_vals()
	var speed = move_vals[0]
	var accel = move_vals[1]
	var drag = move_vals[2]

	var direction = Vector3.ZERO
	var h_rot : float = global_transform.basis.get_euler().y
	var f_input : float = Input.get_axis("move_up", "move_down")
	var h_input : float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: direction = Vector3.ZERO # lock movement input in menus
	if direction != Vector3.ZERO:
		_first_input_check()
	
	var wish_vel = direction * speed
	
	if !is_on_floor(): # airstrafing
		var angle_diff : float = rad_to_deg(_get_horizontal_angle(velocity, wish_vel))
		var sample_point = (angle_diff - strafe_angle_min) / strafe_angle_max
		#velocity += wish_vel.normalized() * delta * airStrafeCurve.sample(samplePoint) * airSpeed
		var air_strafe_additive = (air_strafe_curve.sample(sample_point) * air_strafe_modifier)
		wish_vel *= 1.0 + air_strafe_additive
		console_ui.airstrafe_val_update(air_strafe_additive)
	
	if direction.length() > 0:
		velocity = lerp(velocity, wish_vel, accel * delta)
	else:
		velocity = lerp(velocity, wish_vel, drag * delta)
	
	velocity.y -= gravity * delta
	move_and_slide()

func _shotgun_bounce(direction, force): # bounce the player, sent by the shotgun script
	var bounce_mod = 1.0
	if state == Enums.PlayerState.CROUCHING: bounce_mod += 0.2
	if state == Enums.PlayerState.CROUCHING && is_on_floor(): bounce_mod += 0.2
	if is_on_wall(): bounce_mod += 0.2
	console_ui.bounce_mod_update(bounce_mod)
	velocity = velocity * 0.8
	
	velocity.x += direction.x * force * bounce_mod
	velocity.y += direction.y * force * bounce_mod
	velocity.z += direction.z * force * bounce_mod

func _explosion_bounce(direction, force, smoke_trail_amount): # direction and force determined by the explosion script
	velocity.x += direction.x * force
	velocity.y += direction.y * force
	velocity.z += direction.z * force
	explosion_trail_spawner.spawn(smoke_trail_amount) # to be implemented

func _net_bounce(net_normal):
	# should bounce vector based on the nets normal (Vector3.bounce())
	# for now:
	#velocity.y = -velocity.y * 0.95
	velocity = velocity.bounce(net_normal) * 0.95

func _ring_boost():
	velocity = velocity * 1.5
	Events.add_camera_shake.emit(0.2)

func _input_calc():
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return  # lock movement input in menus
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		_first_input_check()

	# handle movement augmentations (crouching, sliding, sprinting)
	crouching_last_frame = (state == Enums.PlayerState.CROUCHING) # for crouch jumping calc
	if Input.is_action_pressed("crouch"):
		state = Enums.PlayerState.CROUCHING
	elif !test_move(self.global_transform, Vector3(0, crouch_height_difference, 0)):
		# handle sprinting
		if Input.is_action_pressed("sprint"):
			state = Enums.PlayerState.SPRINTING
		else:
			state = Enums.PlayerState.WALKING

	if Input.is_action_just_pressed("attack"):
		Events.fire_weapon.emit()
		_first_input_check() 

	if Input.is_action_just_pressed("toggle_console"):
		if console_ui.visible: console_ui.close()
		else: console_ui.open()
	
	if Input.is_action_pressed("look_behind"):
		head.looking_behind = true
	else:
		head.looking_behind = false

func _handle_crouch(delta):
	if state == Enums.PlayerState.CROUCHING:
		if !is_on_floor() && crouching_last_frame == false: # crouch jump 'teleport
			self.global_position += Vector3(0.0, crouch_height_difference + crouch_jump_offset, 0.0)
			head.position.y = original_head_pos.y + -crouch_height_difference

		head.position.y =  lerp(head.position.y, original_head_pos.y - crouch_height_difference, delta * crouch_headspeed)
		standing_collision_shape.disabled = true; crouching_collision_shape.disabled = false
	else:
		if !is_on_floor() && crouching_last_frame == true && !test_move(self.global_transform, Vector3(0, -crouch_height_difference, 0)):
			self.global_position += Vector3(0.0, -crouch_height_difference - crouch_jump_offset, 0.0)
			head.position.y = original_head_pos.y
		
		head.position.y =  lerp(head.position.y, original_head_pos.y, delta * crouch_headspeed)
		standing_collision_shape.disabled = false; crouching_collision_shape.disabled = true

func _handle_landing_cam(): # this is insanely fucking messy and unoptimized :)
	if !is_on_floor():
		if velocity.y < verticalForce : 		# recording the amount of vertical force to enact on the camera after falling
			verticalForce = velocity.y  		# force is based on the distance of the fall
		verticalForceStorage = verticalForce
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

func _fucking_die(type : Enums.PlayerDeathType):
	queue_free()
	# add death animation ?

func _first_input_check():
	if Gamestate.has_moved == false:
		Events.first_movement.emit()

func _camera_control(event): # sent by main script, having to bypass because main subviewport is greedy & gluttonous
	var relative = Vector2(event.relative.x * (mouse_sense / 600), event.relative.y *  (mouse_sense / 600))
	rotation.y -= relative.x
	head.rotation.x -= relative.y
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
	viewmodel_camera.sway(Vector2(relative.x * 800.0, relative.y * 800.0))



func _establish_events():
	###### game events
	Events.shotgun_bounce.connect(_shotgun_bounce)
	Events.explosion_bounce.connect(_explosion_bounce)
	Events.player_death.connect(_fucking_die)
	Events.fps_mouse_movement.connect(_camera_control)
	Events.net_bounce.connect(_net_bounce)
	Events.ring_boost.connect(_ring_boost)
	
	###### settings events
	Events.set_sens.connect(_set_sensitivity)
	#Events.set_crouch_toggle.connect(_set_crouch_toggle) # unimplemented
	# Events.set_fov is connected in the head script
	
func _establish_settings():
	# establish settings values
	Keeper.load_settings() # refresh
	mouse_sense = Keeper.settings_data["sensitivity"]
	head.set_fov(Keeper.settings_data["fov"])
	#crouch_toggle = Keeper.settings_data["crouch toggle"]

func _set_sensitivity(sensitivity):
	mouse_sense = sensitivity

#func _set_crouch_toggle(toggle):
	#crouch_toggle = toggle


func _debug_label_update():
	#console_ui.speed_update(speed)
	console_ui.velocity_update(Vector2(velocity.x, velocity.z))
	console_ui.combi_velocity_update(snapped(sqrt(velocity.x ** 2 + velocity.z ** 2), 0.001))


# helper methods
func _get_horizontal_angle(vec1 : Vector3, vec2 : Vector3) -> float:
	vec1.y = 0
	vec2.y = 0
	return abs(vec1.angle_to(vec2))

func _get_movestate_vals(): # helper method, moved for organization
	var movevals = [0.0, 0.0, 0.0] 

	if !is_on_floor():
		movevals[0] = speeds["air"]
		movevals[1] = accels["air"]
		movevals[2] = drags["air"]
	else:
		match state:
			Enums.PlayerState.WALKING: 
				movevals[0] = speeds["walk"]
				movevals[1] = accels["floor"]
				movevals[2] = drags["floor"]
			Enums.PlayerState.SPRINTING: 
				movevals[0] = speeds["sprint"]
				movevals[1] = accels["floor"]
				movevals[2] = drags["floor"]
			Enums.PlayerState.CROUCHING: 
				movevals[0] = speeds["crouch"]
				movevals[1] = accels["crouch"]
				movevals[2] = drags["crouch"]
	return movevals
