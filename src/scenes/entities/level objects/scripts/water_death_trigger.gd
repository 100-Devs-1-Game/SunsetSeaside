extends Node3D


func _on_death_area_body_entered(body: Node3D) -> void:
	if body.has_meta(&"Player"):
		Events.player_death.emit(Enums.PlayerDeathType.INSTANT)
