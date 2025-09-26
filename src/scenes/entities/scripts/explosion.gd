extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("explosion")
	#await get_tree().process_frame # await one frame for position to be set
	#AudioManager.create_sound_effect_3d(explosion_sound, self.global_position)	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
