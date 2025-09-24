extends StaticBody3D

func _break():
	queue_free()
	# add particle effects here later
	
func _on_damageable_damaged() -> void: _break()
