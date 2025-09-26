extends StaticBody3D

const EXPLOSION = preload("res://scenes/entities/explosion.tscn")
const BLAST_DECAL = preload("res://scenes/player/shotgun/cannon_blast_decal.tscn")
const SMOKE_SPREAD = preload("res://scenes/player/smoke_spread.tscn")

var explosion_decal_size = 5.0

func _on_damageable_damaged() -> void:
	_spawn_explosion()
	_spawn_decal()
	_spawn_particles()
	queue_free()
	
func _spawn_explosion():
	var new_explosion = EXPLOSION.instantiate()
	add_sibling(new_explosion)
	new_explosion.global_position = global_position
	
func _spawn_decal():
	var new_decal = BLAST_DECAL.instantiate()
	#get_collider.add_child(new_decal)
	self.add_sibling(new_decal) # change this!
	# positioning
	new_decal.global_position = self.global_position - Vector3(0.0, 1.0, 0.0)
	new_decal.transform.basis = Basis.looking_at(Vector3.DOWN)
	new_decal.rotation.x += deg_to_rad(90) # rotate decal forward (this works, no fucking clue)
	new_decal.rotation.y = randf_range(0, 2 *PI)
	# affect decal based on range from collision point
	new_decal.decal_3d.size.x = explosion_decal_size
	new_decal.decal_3d.size.z = explosion_decal_size

func _spawn_particles():
	var new_particles = SMOKE_SPREAD.instantiate()
	new_particles.global_position = self.global_position
	self.add_sibling(new_particles)
	# create custom particles for explosive barrels
	#new_particles.scale = explosion_particles_scale
