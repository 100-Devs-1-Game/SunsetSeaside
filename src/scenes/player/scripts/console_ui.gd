extends Control

@onready var debug_label_fps: Label = $VBoxContainer/debug_label_fps
@onready var debug_label_speed: Label = $VBoxContainer/debug_label_speed
@onready var debug_label_velocity: Label = $VBoxContainer/debug_label_velocity
@onready var debug_label_bounce_mod: Label = $VBoxContainer/debug_label_bounce_mod

#### called by the player script
func velocity_update(velocity): debug_label_velocity.text = "velocity: " + str(snapped(velocity.x, 0.01)) + ", " + str(snapped(velocity.y, 0.01))
func speed_update(speed): debug_label_speed.text = "speed: " + str(speed)
func bounce_mod_update(bounce_mod): debug_label_bounce_mod.text = "last bounce mod: " + str(bounce_mod)

func _ready():
	if !visible: set_process(false)

func _process(delta):
	debug_label_fps.text = "fps: " + str(Engine.get_frames_per_second())

func open(): visible = true; set_process(true)
func close(): visible = false; set_process(false)
