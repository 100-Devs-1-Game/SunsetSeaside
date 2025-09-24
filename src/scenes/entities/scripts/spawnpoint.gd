extends Node3D

func _ready():
	Events.establish_spawnpoint.emit(self)
