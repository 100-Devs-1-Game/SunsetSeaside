extends Resource
class_name SFX_Setting
enum SOUND_EFFECT {
	CANNON_SHOT,
	EXPLOSION,
	JUG_COLLECT,
	CHEST_OPEN,
	RESULTS_TICKING,
	SPINNER_TIME,
	SPINNER_PAR,
	SPINNER_JUG,
	UI_PRESSED,
	PLANK_BREAK,
	SPLASH,
	NET_BOUNCE,
	SQUAWK,
	FOOTSTEP
}

@export var name : SOUND_EFFECT
@export var audio_file : AudioStream
@export_range(-40, 20) var volume = 0 # db?
@export_range(0.0, 4.0, .01) var pitch_scale = 1.0
@export_range(0.0, 1.0, .01) var pitch_randomness = 0.0
@export var limit : int = 5

var audio_count = 0

func change_audio_count(amount : int):
	audio_count = max(0, audio_count + amount)
	
func under_limit():
	return audio_count < limit

func on_audio_finished():
	change_audio_count(-1)
