extends Node3D

@onready var animation_player: AnimationPlayer = $mesh/AnimationPlayer
@onready var reversal_timer: Timer = $mesh/reversal_timer
@onready var speech_positioner: Node3D = $speech_positioner

const FLOATING_LABEL = preload("res://scenes/entities/level objects/floating_label.tscn")

@export var parrot_speech : Array[ParrotSpeech]
@export var speech_start_time := 0.0 # seconds

var speech_index = 0

var reversed = false
var reversal_timer_wait_range = Vector2(1.2, 14.0)

func _ready():
	animation_player.play("head_loop")
	reversal_timer.wait_time = randf_range(reversal_timer_wait_range.x, reversal_timer_wait_range.y)
	if parrot_speech.size() > 0:
		next_parrot_speak()

func next_parrot_speak():
	var new_speak = FLOATING_LABEL.instantiate()
	
	

func _on_reversal_timer_timeout() -> void: # using reversals of the animation to create the illusion of no loop
	reversed = !reversed
	if reversed: animation_player.play("head_loop", -1, -1.0, false)
	else: animation_player.play("head_loop", -1, 1.0, false)
	
	reversal_timer.wait_time = randf_range(reversal_timer_wait_range.x, reversal_timer_wait_range.y)
