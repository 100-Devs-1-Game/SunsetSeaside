extends Node3D

var rotation_speed : float = 0.0

func _physics_process(delta: float):
	rotation.y += rotation_speed * delta
