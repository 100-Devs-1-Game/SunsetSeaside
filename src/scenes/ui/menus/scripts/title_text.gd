extends SubViewportContainer

@export var wave_speed_z : float
@export var wave_speed_x : float
@export var tilt_amount_z : float ## degrees
@export var tilt_amount_x : float ## degrees
@export var wave_speed_pos : float
@export var wave_amp_pos : float

var z_increment : float
var x_increment : float
var x_pos_increment : float

var global_pos_origin

@export var mesh_container: Node3D
@export var mesh_container2: Node3D

func _ready():
	global_pos_origin = global_position

func _physics_process(delta: float) -> void:
	z_increment += wave_speed_z * delta
	z_increment = wrapf(z_increment, 0.0, 2 * PI)
	
	x_increment += wave_speed_x * delta
	x_increment = wrapf(x_increment, 0.0, 2 * PI)
	
	x_pos_increment += wave_speed_pos * delta
	x_pos_increment = wrapf(x_pos_increment, 0.0, 2 * PI)
	
	mesh_container.rotation.z = deg_to_rad(sin(z_increment) * tilt_amount_z)
	mesh_container.rotation.x = deg_to_rad(sin(x_increment) * tilt_amount_x)
	mesh_container.position.y = global_pos_origin.y + sin(x_pos_increment) * wave_amp_pos

	mesh_container2.rotation.z = deg_to_rad(sin(z_increment) * tilt_amount_z)
	mesh_container2.rotation.x = deg_to_rad(sin(x_increment) * tilt_amount_x)
	mesh_container2.position.y = global_pos_origin.y + sin(x_pos_increment) * wave_amp_pos
