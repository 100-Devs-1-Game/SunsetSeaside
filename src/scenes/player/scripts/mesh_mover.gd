extends Node3D
# responsible for animating and resetting recoil for weapons,
# also used as a base for the default position of the mesh

### a weapons model and components that move with it should be placed
### under a Node3D named 'mesh'
@onready var mesh = $mesh

### points for mod meshes
@onready var attachment_point = $mesh/attachment_point

@export var instant_recoil : Vector3 ## x is back, y is up and down, z is side to side
@export var instant_rotation : Vector3 ## x is spin, y is left and right, z is up and down
@export var instant_rotation_variance : Vector3 ## random variance from the instant rotation number (0.5 with a variance of 0.1 could be from 0.4 to 0.6)

@export_category("")
@export var recoil_velocity_amount : Vector3  ## x is back, y is up and down, z is side to side
@export var recoil_torque_amount : Vector3 ## x is spin, y is left and right, z is up and down

@export_category("")
@export var delta_multiplier_pos : float ## the multiplier to the delta value of the return to position lerps
@export var delta_multiplier_rot : float ## the multiplier to the delta value of the return to position lerps
@export var delta_multiplier_velocity_decrease : float ## the multiplier to the delta value of the return to position lerps
@export var delta_multiplier_torque_decrease : float

var recoil_velocity = Vector3.ZERO
var recoil_torque = Vector3.ZERO

func _process(delta):	
	### recoil processing
	# recoil velocity affects
	mesh.position += recoil_velocity * delta
	mesh.rotation += recoil_torque * delta
	
	# recoil velocity decrease
	recoil_velocity = lerp(recoil_velocity, Vector3.ZERO, delta * delta_multiplier_velocity_decrease)	
	recoil_torque = lerp(recoil_torque, Vector3.ZERO, delta * delta_multiplier_torque_decrease)
	
	# position and rotation return
	mesh.position.x = lerp(mesh.position.x, 0.0, delta * delta_multiplier_pos) 
	mesh.position.y = lerp(mesh.position.y, 0.0, delta * delta_multiplier_pos)
	mesh.position.z = lerp(mesh.position.z, 0.0, delta * delta_multiplier_pos)
	
	
	mesh.rotation.x = lerp(mesh.rotation.x, 0.0, delta * delta_multiplier_rot) 	
	mesh.rotation.y = lerp(mesh.rotation.y, 0.0, delta * delta_multiplier_rot) 
	mesh.rotation.z = lerp(mesh.rotation.z, 0.0, delta * delta_multiplier_rot)

func recoil(): ### impart recoil affects
	# instant recoil
	mesh.position.x += instant_recoil.x # back
	mesh.position.y += instant_recoil.y # up	
	mesh.position.z += instant_recoil.z # sideways
	
	mesh.rotation.x += instant_rotation.x + randf_range(-instant_rotation_variance.x, instant_rotation_variance.x) # spin
	mesh.rotation.y += instant_rotation.y + randf_range(-instant_rotation_variance.y, instant_rotation_variance.y) # left / right
	mesh.rotation.z -= instant_rotation.z + randf_range(-instant_rotation_variance.z, instant_rotation_variance.z) # up
	
	recoil_velocity += recoil_velocity_amount
	recoil_torque += recoil_torque_amount
	
