extends Node3D

@onready var animation_player: AnimationPlayer = $mesh/AnimationPlayer
@onready var reversal_timer: Timer = $mesh/reversal_timer
@onready var speech_positioner: Node3D = $speech_positioner

const FLOATING_LABEL = preload("res://scenes/entities/level objects/floating_label.tscn")

@export var parrot_speech : Array[ParrotSpeech]
@export var speech_start_time := 0.0 # seconds
@export var speech_gap_time := 0.0 # seconds

var speech_index = 0

var reversed = false
var reversal_timer_wait_range = Vector2(1.2, 14.0)

func _ready():
	Events.entity_reset.connect(_restart_speech)
	
	animation_player.play("head_loop")
	reversal_timer.wait_time = randf_range(reversal_timer_wait_range.x, reversal_timer_wait_range.y)
	# called by entity_reset on level load
	#if parrot_speech.size() > 0:
		#await get_tree().create_timer(speech_start_time).timeout 
		#_next_parrot_speak()

func _next_parrot_speak():
	if !speech_index < parrot_speech.size(): return
	
	var new_speak = FLOATING_LABEL.instantiate()
	new_speak.macaw_text = true
	new_speak.fade_out = true
	new_speak.label_has_faded.connect(speak_faded)
	
	speech_positioner.add_child(new_speak)
	new_speak.label_text = parrot_speech[speech_index].text
	new_speak.fade_out_pretime = parrot_speech[speech_index].fade_out_pretime

	speech_index += 1
	if !Gamestate.hide_macaw_text: DJ.create_audio_3D(SFX_Setting.SOUND_EFFECT.SQUAWK, self.global_position)

func _restart_speech():
	for node in speech_positioner.get_children():
		node.queue_free()
	
	if parrot_speech.size() > 0:
		speech_index = 0
		await get_tree().create_timer(speech_start_time).timeout 
		_next_parrot_speak()

func _on_reversal_timer_timeout() -> void: # using reversals of the animation to create the illusion of no loop
	reversed = !reversed
	if reversed: animation_player.play("head_loop", -1, -1.0, false)
	else: animation_player.play("head_loop", -1, 1.0, false)
	
	reversal_timer.wait_time = randf_range(reversal_timer_wait_range.x, reversal_timer_wait_range.y)

func speak_faded():
	await get_tree().create_timer(speech_gap_time).timeout 
	_next_parrot_speak()
