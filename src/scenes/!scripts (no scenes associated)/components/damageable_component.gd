# this script allows a scene to be damaged
class_name Damageable
extends Node

@export var filter_by_type = false # if the damagable should filter damage based on what type it was
#@export var types_damagable_by : Array[Enums.DamageType] # types the damagable can be damaged by, if toggled

signal damaged(amount : int, type : String, collision_point, collision_normal, impulse)

# hit should be called with these operable parameters
# NOTE: impulse exist mostly for creating movement to debris or etc after a hit, not to the object itself
func hit() : # collision point has default val for if none is specified
	# maybe pass damage type as an array that can hold multiple types?
	emit_signal("damaged")

func _enter_tree() -> void:
	owner.set_meta(&"Damageable", self) # register
func _exit_tree() -> void:
	if owner != null:
		owner.remove_meta(&"Damageable") # unregister


func _on_damaged(amount, type, collision_point, collision_normal, impulse):
	pass # Replace with function body.


func _on_health_component_death():
	pass # Replace with function body.
