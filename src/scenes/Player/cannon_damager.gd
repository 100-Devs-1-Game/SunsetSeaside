extends Node3D

@export var damage_range = 4.0 # meters

func _ready():
	for caster in get_children(): # set cannon range
		caster.target_position.z = -damage_range

func damage():
	for caster in get_children():
		caster.enabled = true
		caster.force_raycast_update()
		if caster.is_colliding():
			var body = caster.get_collider()
			if body.has_meta(&"Damageable"):
				var damageable = body.get_meta(&"Damageable")
				damageable.hit()		
