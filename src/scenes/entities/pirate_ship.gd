extends Node3D

@export var wave_speed_z : float
@export var wave_speed_x : float
@export var tilt_amount_z : float ## degrees
@export var tilt_amount_x : float ## degrees

var z_increment : float
var x_increment : float

func _physics_process(delta: float) -> void:
	z_increment += wave_speed_z * delta
	z_increment = wrapf(z_increment, 0.0, 2 * PI)
	
	x_increment += wave_speed_x * delta
	x_increment = wrapf(x_increment, 0.0, 2 * PI)
	
	rotation.z = deg_to_rad(sin(z_increment) * tilt_amount_z)
	rotation.x = deg_to_rad(sin(x_increment) * tilt_amount_x)
