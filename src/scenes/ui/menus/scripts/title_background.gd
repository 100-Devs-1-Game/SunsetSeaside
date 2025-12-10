extends Node3D

@export var camera : Camera3D

@export var pos_start : RayCast3D
@export var pos_title :  RayCast3D
@export var pos_settings :  RayCast3D
@export var pos_levels :  RayCast3D

var camera_travel_speed = 2.0
var camera_rotation_speed = 4.0

var current_goal_pos : RayCast3D = null

func _ready():
	Events.set_title_position.connect(_set_title_position)
	_move_cam_to_pos(pos_start)
	current_goal_pos = pos_title
	
func _move_cam_to_pos(pos : RayCast3D):
	camera.global_position = pos.global_position
	camera.global_rotation = pos.global_rotation

func _physics_process(delta: float) -> void:
	
	camera.global_position = lerp(camera.global_position, current_goal_pos.global_position, camera_travel_speed * delta)
	camera.global_rotation = lerp(camera.global_rotation, current_goal_pos.global_rotation, camera_rotation_speed * delta)

func _set_title_position(pos : Enums.TitlePosition):
	var new_pos = null
	match pos:
		Enums.TitlePosition.START: new_pos = pos_start
		Enums.TitlePosition.TITLE: new_pos = pos_title
		Enums.TitlePosition.LEVELS: new_pos = pos_levels
		Enums.TitlePosition.SETTINGS: new_pos = pos_settings
	
	current_goal_pos = new_pos
