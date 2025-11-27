extends Node3D
# applies damage to object infront of the cannon using raycasts

@export var damage_range = 4.0 # meters
var already_damaged : Array

func _ready():
	for caster in get_children(): # set cannon range
		caster.target_position.z = -damage_range

func damage():
	already_damaged = [] # reset what has been already damaged each shot
	for caster in get_children():
		caster.enabled = true
		caster.force_raycast_update()
		if caster.is_colliding():
			var body = caster.get_collider()
			attempt_damage(body)
			
func attempt_damage(body):
		for node in already_damaged:
			if node == body: # check to see if object has already been damaged this action
				return 

		if body.has_meta(&"Damageable"):
			var damageable = body.get_meta(&"Damageable")
			damageable.hit()	
			already_damaged.append(body)
