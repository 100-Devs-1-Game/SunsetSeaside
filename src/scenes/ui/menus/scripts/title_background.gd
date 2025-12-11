extends Node3D

@export var camera : Camera3D
@export var camera_mount : Node3D

@export var pos_start : RayCast3D
@export var pos_title :  RayCast3D
@export var pos_settings :  RayCast3D
@export var pos_levels :  RayCast3D

@onready var world_environment: WorldEnvironment = $WorldEnvironment

const ENV_SUNSET = preload("res://assets/skyboxes/sunset.tres")
const ENV_MIDNIGHT = preload("res://assets/skyboxes/midnight.tres")
const ENV_BONUS = preload("res://assets/skyboxes/bonus.tres")

var camera_travel_speed = 2.0
var camera_rotation_speed = 4.0

var current_goal_ray : RayCast3D = null

func _ready():
	Events.set_title_position.connect(_set_title_position)
	Events.force_title_position.connect(_move_cam_to_pos)
	Events.skybox_switch.connect(_switch_skybox)
	_move_cam_to_pos(Enums.TitlePosition.START)
	current_goal_ray = pos_title
	
func _move_cam_to_pos(pos : Enums.TitlePosition):
	camera_mount.global_position = _get_ray_from_enum(pos).global_position
	camera_mount.global_rotation = _get_ray_from_enum(pos).global_rotation

func _physics_process(delta: float) -> void:
	
	camera_mount.global_position = lerp(camera_mount.global_position, current_goal_ray.global_position, camera_travel_speed * delta)
	camera_mount.global_rotation = lerp(camera_mount.global_rotation, current_goal_ray.global_rotation, camera_rotation_speed * delta)

func _set_title_position(pos : Enums.TitlePosition):
	current_goal_ray = _get_ray_from_enum(pos)

func _get_ray_from_enum(pos : Enums.TitlePosition):
	var raycast = null
	match pos:
		Enums.TitlePosition.START: raycast = pos_start
		Enums.TitlePosition.TITLE: raycast = pos_title
		Enums.TitlePosition.LEVELS: raycast = pos_levels
		Enums.TitlePosition.SETTINGS: raycast = pos_settings
	return raycast
	
func _switch_skybox(skybox : Enums.Skybox):
	var new_environment
	match skybox:
		Enums.Skybox.SUNSET: new_environment = ENV_SUNSET
		Enums.Skybox.MIDNIGHT: new_environment = ENV_MIDNIGHT
		Enums.Skybox.BONUS: new_environment = ENV_BONUS
		
	world_environment.environment = new_environment
