extends SubViewportContainer

@export var rotation_speed = 0.6
@export var rotation_start_offset = -100.0 # degrees

var shake_amount = 0.0
var shake_fade = 3.0

var offset_global_pos = Vector3(-2048, -2048, -2048) # offset from the level space for creating distance from spotlights
var offset_instance_pos_x = -4.0 # amount of offset based on instance number

@onready var spinner_positioner: Node3D = $SubViewport/spinner_positioner
@onready var spinner_mesh_container: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container
@onready var spinner_rot_offset: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset
@onready var debug_mesh: MeshInstance3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset/debug_mesh

@onready var ready_mesh: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset/ready_mesh
@onready var partial_mesh: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset/partial_mesh
@onready var empty_mesh: Node3D = $SubViewport/spinner_positioner/spinner_mesh_container/spinner_rot_offset/empty_mesh

@export var spinner_visible_on_start = false
@export var instance : int = 1 # for manual camera offsetting

func _ready():
	Events.ui_ammo_state_switch.connect(_ammo_state_switched)
	spinner_mesh_container.rotation.y += deg_to_rad(rotation_start_offset)
	spinner_mesh_container.rotation_speed = rotation_speed
	
	offset_position(5)

func _process(delta):
	# process mesh shaking
	if shake_amount > 0:
		shake_amount = lerpf(shake_amount, 0.0, shake_fade * delta)
		var shake_offset = Vector2(randf_range(-shake_amount, shake_amount),randf_range(-shake_amount, shake_amount))
		spinner_mesh_container.position.x = shake_offset.x
		spinner_mesh_container.position.y = shake_offset.y
		### this is a work around, maybe find the true solution later? (the division)

func _ammo_state_switched(state : Enums.AmmoState):
	for mesh in spinner_rot_offset.get_children():
		mesh.visible = false
	
	match state:
		Enums.AmmoState.READY: ready_mesh.visible = true
		Enums.AmmoState.PARTIAL: partial_mesh.visible = true
		Enums.AmmoState.EMPTY: empty_mesh.visible = true

func offset_position(spinner_instance : int):
	spinner_positioner.global_position = offset_global_pos + Vector3(offset_instance_pos_x * spinner_instance, 0.0, 0.0)

func mesh_visibility(visibility):
	if visibility: spinner_rot_offset.visible = true
	else: spinner_rot_offset.visible = false

func get_mesh_visibility():
	return spinner_rot_offset.visible
