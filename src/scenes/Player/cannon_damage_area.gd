extends Area3D

func damage():
	self.monitoring = true
	await Engine.get_main_loop().process_frame
	self.monitoring = false


func _on_body_entered(body: Node3D) -> void:
	print("jah")
	if body.has_meta(&"Damageable"):
		print("gaj")
		var damageable = body.get_meta(&"Damageable")
		damageable.hit()
		#var impulse = [(body.global_transform.origin - collision_point).normalized() * force, ((collision_point - owner.global_transform.origin).normalized())]
		#damageable.hit(damage, type, collision_point, collision_normal, impulse)
		#print_debug(body.name + " took " + str(damage) + " damage, type ", type)
		#
