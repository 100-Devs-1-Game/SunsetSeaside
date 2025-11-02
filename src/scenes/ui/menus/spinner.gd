extends SubViewportContainer

var rotation_speed = 0.6
var rotation_start_offset = -100.0 # degrees

var shake_amount = 0.0
var shake_fade = 3.0

var offset_global_pos = Vector3(-512, -512, -512) # offset from the level space for creating distance from spotlights
var offset_instance_pos_x = -4.0 # amount of offset based on instance number

@onready var spinner_positioner: Node3D = $SubViewport/spinner_positioner
@onready var spinner_mesh_container: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container
@onready var spinner_rot_offset: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset
@onready var debug_mesh: MeshInstance3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset/debug_mesh

@export var spinner_mesh : PackedScene

func _process(delta):
	# process mesh shaking
	if shake_amount > 0:
		shake_amount = lerpf(shake_amount, 0.0, shake_fade * delta)
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount),randf_range(-shake_amount, shake_amount))
		spinner_mesh_container.position.x = shake_offset.x
		spinner_mesh_container.position.y = shake_offset.y
		### this is a work around, maybe find the true solution later? (the division)

func _ready():
	spinner_mesh_container.rotation.y += deg_to_rad(rotation_start_offset)
	spinner_mesh_container.rotation_speed = rotation_speed
	if spinner_mesh:
		debug_mesh.visible = false
		var new_mesh = spinner_mesh.instantiate()
		spinner_rot_offset.add_child(new_mesh)

func offset_position(spinner_instance : int):
	spinner_positioner.global_position = offset_global_pos + Vector3(offset_instance_pos_x * spinner_instance, 0.0, 0.0)

func mesh_visibility(visibility):
	if visibility: spinner_rot_offset.visible = true
	else: spinner_rot_offset.visible = false
