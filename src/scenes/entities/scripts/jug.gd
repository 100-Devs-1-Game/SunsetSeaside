extends Node3D
# gug

@onready var mesh_container: Node3D = $mesh_container
@onready var mesh_spinner: Node3D = $mesh_container/mesh_spinner
@onready var mesh_spinner_outer: Node3D = $mesh_container/mesh_spinner_outer
@onready var area_3d: Area3D = $Area3D

var rotation_speed = 1.0
var wave_speed = 1.0
var wave_amp = 0.08

var wave_increment : float = 0.0

func _ready():
	Events.entity_reset.connect(_reset)

func _physics_process(delta):
	# animate mesh
	mesh_spinner.rotation.y += rotation_speed * delta
	mesh_spinner_outer.rotation.y -= rotation_speed * delta
	
	wave_increment += wave_speed * delta
	wave_increment = wrapf(wave_increment, 0.0, 2 * PI)
	mesh_container.position.y = sin(wave_increment) * wave_amp

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.jug_collected.emit()
		# play sound
		# particles?
		mesh_container.visible = false
		area_3d.monitoring = false
		
func _reset():
	mesh_container.visible = true
	area_3d.monitoring = true
