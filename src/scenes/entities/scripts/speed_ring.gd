extends Node3D

@onready var mesh: Node3D = $mesh
var rotation_amount = 0.6

func _process(delta):
	mesh.rotation.z += rotation_amount * delta

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.ring_boost.emit()
		print("ring")
