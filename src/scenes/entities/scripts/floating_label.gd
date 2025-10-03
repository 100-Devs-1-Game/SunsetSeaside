extends Label3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var label_text = ""
@export var fade_out = true

func _ready():
	self.text = label_text
	if fade_out == true: fade_text()

func fade_text():
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
