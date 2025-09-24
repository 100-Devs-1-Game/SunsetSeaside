extends StaticBody3D


func _on_damageable_damaged() -> void:
	queue_free()
	
