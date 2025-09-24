extends StaticBody3D

@onready var fragile_timer: Timer = $fragile_timer

func _break():
	queue_free()
	# add particle effects here later

func _on_area_3d_body_entered(body: Node3D) -> void: fragile_timer.start();
func _on_fragile_timer_timeout() -> void: _break()
func _on_damageable_damaged() -> void: _break()
