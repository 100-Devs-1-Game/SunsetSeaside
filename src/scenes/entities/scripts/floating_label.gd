@tool
extends Label3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_category("label properties")
@export var label_text = "" :
	get: return label_text
	set(value): 
		self.text = value
		label_text = value

@export var label_text_size = 32:
	get: return label_text_size
	set(value):
		self.font_size = value
		label_text_size = value

@export var fade_out = true

##
#func _ready():
	#self.text = label_text
	#self.font_size = label_text_size
	#if fade_out == true: fade_text()

func fade_text():
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
