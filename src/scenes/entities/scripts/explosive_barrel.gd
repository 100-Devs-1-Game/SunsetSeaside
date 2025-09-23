extends StaticBody3D


func _on_damageable_damaged(amount: int, type: String, collision_point: Variant, collision_normal: Variant, impulse: Variant) -> void:
	queue_free()
	
