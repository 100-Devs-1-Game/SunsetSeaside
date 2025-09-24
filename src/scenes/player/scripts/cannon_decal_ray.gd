extends RayCast3D

@export var explosion_decal = preload("res://scenes/Player/shotgun/cannon_blast_decal.tscn")

func create_decal():
	enabled = true; force_raycast_update()
	var collision_point = get_collision_point()
	var collision_normal = get_collision_normal() # declared for optimization
	if is_colliding(): 
		var new_decal = explosion_decal.instantiate()
		#get_collider.add_child(new_decal)
		get_parent().get_parent().get_parent().add_sibling(new_decal) # change this!
		# positioning
		new_decal.global_position = collision_point
		new_decal.transform.basis = Basis.looking_at(collision_normal)
		new_decal.rotation.x += deg_to_rad(90) # rotate decal forward (this works, no fucking clue)
		new_decal.rotate(collision_normal, randf_range(0, 2 *PI))
		# affect decal based on range from collision point
		var distance_ratio = collision_point.distance_to(global_position) / abs(target_position.z)
		new_decal.decal_3d.position.y = distance_ratio * 1.0 # meters
		new_decal.decal_3d.size.x = distance_ratio * 2.4 + 0.8
		new_decal.decal_3d.size.z = distance_ratio * 2.4 + 0.8
	
	
	enabled = false
