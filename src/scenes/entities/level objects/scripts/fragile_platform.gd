extends StaticBody3D

@onready var fragile_timer: Timer = $fragile_timer
@onready var mesh: Node3D = $mesh
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var area_3d: Area3D = $Area3D
@onready var child_container: Node3D = $child_container

func _on_area_3d_body_entered(body: Node3D) -> void: fragile_timer.start();
func _on_fragile_timer_timeout() -> void: _break()
func _on_damageable_damaged() -> void: _break()
func _ready(): Events.entity_reset.connect(_reset)

func _break():
	mesh.visible = false
	collision_shape_3d.disabled = true
	area_3d.monitoring = false
	# add particle effects here later

func _reset():
	for child in child_container.get_children():
		child.queue_free()
	
	mesh.visible = true
	collision_shape_3d.set_deferred("disabled", false)
	area_3d.monitoring = true
