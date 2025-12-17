@tool
extends Label3D

@onready var fade_timer: Timer = $Timer
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
@export var fade_out_pretime = 1.0 ## time before text fades out
@export var macaw_text : bool = false

signal label_has_faded()

func _ready():
	if Engine.is_editor_hint(): return 

	Events.set_labels_hidden.connect(_hide_macaw_text)

	if macaw_text == true && Gamestate.hide_macaw_text == true:
		visible = false

	if fade_out == true: 
		if fade_out_pretime == null: fade_out_pretime = 0.0
		fade_timer.wait_time = fade_out_pretime
		fade_timer.start()

func _on_timer_timeout() -> void:
	animation_player.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	label_has_faded.emit()
	queue_free()

func _hide_macaw_text(hidden):
	if macaw_text:
		if hidden == true: visible = false
		else: visible = true
