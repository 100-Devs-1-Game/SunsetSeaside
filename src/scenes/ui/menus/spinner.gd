extends SubViewportContainer

var rotation_speed = 0.6
var offset_global_pos = Vector3(-512, -512, -512) # offset from the level space for creating distance from spotlights

var offset_instance_pos_x = -4.0 # amount of offset based on instance number

@onready var spinner_positioner: Node3D = $SubViewport/spinner_positioner
@onready var spinner_mesh_container: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container
@onready var spinner_rot_offset: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset

@export var spinner_mesh : PackedScene

func _ready():
	spinner_mesh_container.rotation_speed = rotation_speed
	if spinner_mesh:
		var new_mesh = spinner_mesh.instantiate()
		spinner_rot_offset.add_child(new_mesh)

func offset_position(spinner_instance : int):
	spinner_positioner.global_position = offset_global_pos + Vector3(offset_instance_pos_x * spinner_instance, 0.0, 0.0)
