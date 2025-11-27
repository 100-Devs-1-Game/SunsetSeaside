extends Node3D

var net_normal : Vector3

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.net_bounce.emit(Vector3.UP)
		Events.floor_reload.emit()
		
