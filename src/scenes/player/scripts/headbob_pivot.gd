extends Node3D
	# head bob
@onready var audio_stream_player_footsteps: AudioStreamPlayer = $AudioStreamPlayer_footstps
@onready var viewmodel_pivot: Node3D = $Camera3D/SubViewportContainer/SubViewport/viewmodel_camera/viewmodel_pivot

### bobbing_intensity
var bobbing_intensity_sprint = 0.8
var bobbing_intensity_walk = 0.3
var bobbing_intensity_crouch = 0.15

var bobbing_vector = Vector2.ZERO
var bobbing_index = 0.0
var bobbing_intensity = 0.0
var bobbing_lerp_y = 3.0
var bobbing_lerp_x = 1.2

var viewmodel_bob_multiplier = 0.012 # amount of bob of the main headbob amount applied to the veiwmodel

var state = Enums.PlayerState.WALKING: # set by the player script when changed
	get: return state
	set(value):
		match value:
			Enums.PlayerState.WALKING: bobbing_intensity = bobbing_intensity_walk
			Enums.PlayerState.SPRINTING: bobbing_intensity = bobbing_intensity_sprint
			Enums.PlayerState.CROUCHING: bobbing_intensity = bobbing_intensity_crouch

#### player variables
#var current_position = Vector3.ZERO
#var position_last_frame = Vector3.ZERO
#var is_on_floor = true
#var input_dir = Vector2.ZERO


func headbob(position_last_frame, is_on_floor, input_dir, player_state, current_position, delta):
	state = player_state
	var distance_traveled_between_frames = abs(sqrt(((position_last_frame.x - current_position.x) * (position_last_frame.x - current_position.x)) + ((position_last_frame.z - current_position.z) * (position_last_frame.z - current_position.z))))
	bobbing_index += distance_traveled_between_frames * 2.2
	bobbing_index = wrapf(bobbing_index, 0.0, PI * 4) # stops the memory leak 
	
	if is_on_floor && input_dir != Vector2.ZERO && distance_traveled_between_frames > 0.005:
		bobbing_vector.y = sin(bobbing_index)
		bobbing_vector.x = sin(bobbing_index / 2)
		_footstep_calc(bobbing_vector)

		position.y = lerp(position.y, bobbing_vector.y * (bobbing_intensity / 2.0), bobbing_lerp_y * delta)
		position.x = lerp(position.x, bobbing_vector.x * (bobbing_intensity), bobbing_lerp_x * delta)
	
		viewmodel_pivot.position.y = lerp(viewmodel_pivot.position.y, -bobbing_vector.y * (bobbing_intensity / 2.0) * viewmodel_bob_multiplier, bobbing_lerp_y * delta)
		viewmodel_pivot.position.x = lerp(viewmodel_pivot.position.x, -bobbing_vector.x * (bobbing_intensity) * viewmodel_bob_multiplier, bobbing_lerp_x * delta)
	
	else:
		position.y = lerp(position.y, 0.0, bobbing_lerp_y * delta * 2)
		position.x = lerp(position.x, 0.0, bobbing_lerp_x * delta * 2)
		
		viewmodel_pivot.position.y = lerp(viewmodel_pivot.position.y, 0.0, bobbing_lerp_y * delta * 2)
		viewmodel_pivot.position.x = lerp(viewmodel_pivot.position.x, 0.0, bobbing_lerp_x * delta * 2)
		

var footstep_alternate = true # flips between true and false to signify each foot
func _footstep_calc(bobbing_vector):
	if bobbing_vector.x > 0.99 && footstep_alternate == false:
		DJ.create_audio(SFX_Setting.SOUND_EFFECT.FOOTSTEP)
		footstep_alternate = true
	elif bobbing_vector.x < -0.99 && footstep_alternate == true:
		DJ.create_audio(SFX_Setting.SOUND_EFFECT.FOOTSTEP)
		footstep_alternate = false
	
