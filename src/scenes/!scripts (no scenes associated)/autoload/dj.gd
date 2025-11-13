extends Node

# manages audio busses, sfx and music playback

var bus_master
var bus_sfx
var bus_music
var bus_ambient

func _ready():
	Events.set_master_vol.connect(_set_master_vol)
	Events.set_sfx_vol.connect(_set_sfx_vol)
	Events.set_music_vol.connect(_set_music_vol)
	Events.set_ambient_vol.connect(_set_ambient_vol)
	
	# setup bus volumes
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
	
func _set_master_vol(volume): _adjust_bus_volume("Master", volume);
func _set_sfx_vol(volume): _adjust_bus_volume("SFX", volume)
func _set_music_vol(volume): _adjust_bus_volume("Music", volume)
func _set_ambient_vol(volume): _adjust_bus_volume("Ambient", volume)
