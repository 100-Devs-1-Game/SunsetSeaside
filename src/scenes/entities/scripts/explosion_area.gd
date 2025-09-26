extends Area3D

@onready var explosion_area_mesh = $explosion_area_mesh

var force = 25.0 # set this as an export related to the mesh entity later
var shake_intensity = 0.6 # affected by a ratio in relation to distance
var shake_range = 12.0 # meters
@onready var area_shape: CollisionShape3D = $area_shape

func _on_body_entered(body):
	#for node in already_effected:
		#if node == body:
			#return
	if body is CharacterBody3D : print(body)
	
	if body.has_meta(&"Damageable"):
		var damageable = body.get_meta(&"Damageable")
		damageable.hit()		
	
	if body.has_meta(&"Player"):
		var direction = (self.global_transform.origin - body.global_transform.origin).normalized()
		var distance = self.global_position.distance_to(body.global_position)
		var force_ratio = 1.0 - (distance / area_shape.shape.radius)
		print(force * force_ratio)
		Events.explosion_bounce.emit(-direction, force * force_ratio, 1.0 ) # <- to be calculated soon)
		Events.add_camera_shake.emit(shake_intensity * (1.0 - (distance / shake_range)))
