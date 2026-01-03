extends Node3D

@export var explosive_barrel : StaticBody3D

func _ready():
	Events.explode_title_barrel.connect(_explode_barrel)

func _explode_barrel():
	if explosive_barrel != null:
		explosive_barrel._on_damageable_damaged()
