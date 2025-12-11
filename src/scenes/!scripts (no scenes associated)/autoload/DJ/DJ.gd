extends Node
# manages audio busses, sfx and music playback
# written in part with help from Aarimous, cheers!
# https://www.youtube.com/watch?v=Egf2jgET3nQ&t=130s

@onready var music_player: AudioStreamPlayer = $music_player
@onready var ambient_player: AudioStreamPlayer = $ambient_player
@onready var sfx_container: Node3D = $sfx_container

@export var sfx_settings : Array[SFX_Setting]

enum Music { MONKEYS_DOMAIN }
enum Ambience { JUNGLE_DAY, JUNGLE_NIGHT }

var sfx_dict = {}

func _ready():
	_setup_events()
	_setup_bus_volume()
	# setup dict 
	for setting in sfx_settings:
		sfx_dict[setting.name] = setting

#### busses
func _setup_bus_volume():
	Keeper.load_settings()
	
	_adjust_bus_volume("Master", Keeper.settings_data["master vol"])
	_adjust_bus_volume("SFX", Keeper.settings_data["sfx vol"])
	_adjust_bus_volume("Music", Keeper.settings_data["music vol"])
	_adjust_bus_volume("Ambient", Keeper.settings_data["ambient vol"])

func _adjust_bus_volume(bus, new_volume):
	var bus_index
	match bus:
		"Master" : bus_index = 0
		"SFX" : bus_index = 1
		"Music" : bus_index = 2
		"Ambient" : bus_index = 3
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_volume / 100.0))

func create_audio_3D(effect_name : SFX_Setting.SOUND_EFFECT, position : Vector3):
	if !sfx_dict.has(effect_name): push_error("Unable to find " + str(effect_name) + "in sfx settings!")
	else:
		var sfx_setting = sfx_dict[effect_name]
		if !sfx_setting.under_limit(): return
		var new_audio = AudioStreamPlayer3D.new()
		#sfx_container.add_child(new_audio)
		add_child(new_audio)
		
		new_audio.stream = sfx_setting.audio_file
		new_audio.volume_db = sfx_setting.volume
		new_audio.pitch_scale = sfx_setting.pitch_scale
		new_audio.pitch_scale += randf_range(-sfx_setting.pitch_randomness, sfx_setting.pitch_randomness)
		new_audio.finished.connect(sfx_setting.on_audio_finished)
		new_audio.finished.connect(new_audio.queue_free)
		
		new_audio.set_bus(&"SFX")
		new_audio.global_position = position
		
		new_audio.play()
		
func create_audio(effect_name : SFX_Setting.SOUND_EFFECT):
	if !sfx_dict.has(effect_name): push_error("Unable to find " + str(effect_name) + "in sfx settings!")
	else:
		var sfx_setting = sfx_dict[effect_name]
		if !sfx_setting.under_limit(): return
		
		var new_audio = AudioStreamPlayer.new()
		sfx_container.add_child(new_audio)
		
		new_audio.stream = sfx_setting.audio_file
		new_audio.volume_db = sfx_setting.volume
		new_audio.pitch_scale = sfx_setting.pitch_scale
		new_audio.pitch_scale += randf_range(-sfx_setting.pitch_randomness, sfx_setting.pitch_randomness)
		new_audio.finished.connect(sfx_setting.on_audio_finished)
		new_audio.finished.connect(new_audio.queue_free)

		new_audio.set_bus(&"SFX")
		new_audio.play()

#### music and ambience
func switch_music(music_name : DJ.Music):
	music_player["parameters/switch_to_clip"] = _get_music_from_enum(music_name)
	if !music_player.playing: music_player.playing = true

func switch_ambience(ambience_name : DJ.Ambience):
	ambient_player["parameters/switch_to_clip"] = _get_ambience_from_enum(ambience_name)
	if !ambient_player.playing: ambient_player.playing = true

func _get_music_from_enum(music_name : DJ.Music):
	match music_name:
		DJ.Music.MONKEYS_DOMAIN: return "monkey's domain"

func _get_ambience_from_enum(ambience_name : DJ.Ambience):
	match ambience_name:
		DJ.Ambience.JUNGLE_DAY: return "jungle day"
		DJ.Ambience.JUNGLE_NIGHT: return "jungle night"

#### events
func _setup_events():
	Events.set_master_vol.connect(_set_master_vol)
	Events.set_sfx_vol.connect(_set_sfx_vol)
	Events.set_music_vol.connect(_set_music_vol)
	Events.set_ambient_vol.connect(_set_ambient_vol)
	
func _set_master_vol(volume): _adjust_bus_volume("Master", volume);
func _set_sfx_vol(volume): _adjust_bus_volume("SFX", volume)
func _set_music_vol(volume): _adjust_bus_volume("Music", volume)
func _set_ambient_vol(volume): _adjust_bus_volume("Ambient", volume)
