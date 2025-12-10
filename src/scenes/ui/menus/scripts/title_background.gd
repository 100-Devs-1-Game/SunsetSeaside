extends Node3D

@export var camera : Camera3D
@export var camera_mount : Node3D

@export var pos_start : RayCast3D
@export var pos_title :  RayCast3D
@export var pos_settings :  RayCast3D
@export var pos_levels :  RayCast3D

var camera_travel_speed = 2.0
var camera_rotation_speed = 4.0

var current_goal_ray : RayCast3D = null

func _ready():
	Events.set_title_position.connect(_set_title_position)
	Events.force_title_position.connect(_move_cam_to_pos)
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
