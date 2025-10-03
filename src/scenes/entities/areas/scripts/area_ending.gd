extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.level_end_reached.emit()
  
