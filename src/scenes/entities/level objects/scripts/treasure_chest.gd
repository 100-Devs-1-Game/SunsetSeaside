extends Node3D

@onready var sphere_container: Node3D = $Area3D/sphere_container
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var sphere_rotation_speed = 1.0

func _ready():
	Events.entity_reset.connect(_reset)

func _physics_process(delta):
	# animate mesh
	sphere_container.rotation.y += sphere_rotation_speed * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.level_end_reached.emit()
		animation_player.play("open")

func _reset():
	animation_player.play("RESET")
