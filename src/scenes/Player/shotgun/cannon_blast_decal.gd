extends Node3D

@onready var decal_3d: Decal = $Decal3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("on_spawn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
