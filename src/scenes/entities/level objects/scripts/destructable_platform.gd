extends StaticBody3D

@onready var mesh: Node3D = $mesh
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready():
	Events.entity_reset.connect(_reset)

func _break():
	mesh.visible = false
	collision_shape_3d.disabled = true
	# add particle effects here later
	
func _on_damageable_damaged() -> void: _break()

func _reset():
	mesh.visible = true
	collision_shape_3d.set_deferred("disabled", false)
