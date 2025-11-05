extends Node

const savepath : String = "user://"
var levels_file = "levels.json"
var completion_file = "completion.json"
var settings_file = "settings.json"

var level_data : Dictionary
var completion_data : Dictionary
var settings_data : Dictionary

var access : FileAccess

var enc_key = "theres only 4 years left"

func _ready():
	if !FileAccess.file_exists(savepath + levels_file):
		establish_level_save()
	if !FileAccess.file_exists(savepath + settings_file):
		pass

func establish_level_save():
	level_data = {
		"debug":{},
		"daylight":{},
		"sunset":{},
		"midnight":{},
		"sunrise":{}
	}
	fresh_populate_section("levels_debug")
	fresh_populate_section("levels_tutorial")
	fresh_populate_section("levels_easy")
	fresh_populate_section("levels_medium")
	fresh_populate_section("levels_hard")
	
	save_records()

func fresh_populate_section(level_section):
	var current_section = null
	match level_section:
		"levels_debug" : current_section = "debug"
		"levels_tutorial" : current_section = "daylight"
		"levels_easy" : current_section = "sunset"
		"levels_medium" : current_section = "midnight"
		"levels_hard" : current_section = "sunrise"
	
	var level_array = Gamestate.level_manager.get(level_section)
	for i in level_array.size():
		if !level_data[current_section].has("id" + str(i)):
			level_data[current_section]["id" + str(i)] = {"time_best" : null, "par_best" : null, "jug_history" : false, "hardcore_history" : false}

func get_level_history(grouping, id) -> Dictionary: 
	var level_grouping
	match grouping:
		Enums.LevelGrouping.DEBUG : level_grouping = "debug"
		Enums.LevelGrouping.DAYLIGHT : level_grouping = "daylight"
		Enums.LevelGrouping.SUNSET : level_grouping = "sunset"
		Enums.LevelGrouping.MIDNIGHT : level_grouping = "midnight"
		Enums.LevelGrouping.SUNRISE : level_grouping = "sunrise"
		
	var level_info = {
		"time_best" : level_data[level_grouping]["id" + str(id)]["time_best"],
		"par_best" : level_data[level_grouping]["id" + str(id)]["par_best"],
		"jug_history" : level_data[level_grouping]["id" + str(id)]["jug_history"],
		"hardcore_history" :level_data[level_grouping]["id" + str(id)]["hardcore_history"]
	}
	return level_info

func write_level_history(grouping, id, time_best, par_best, jug_history, hardcore_history):
	var level_grouping
	match grouping:
		Enums.LevelGrouping.DEBUG : level_grouping = "debug"
		Enums.LevelGrouping.DAYLIGHT : level_grouping = "daylight"
		Enums.LevelGrouping.SUNSET : level_grouping = "sunset"
		Enums.LevelGrouping.MIDNIGHT : level_grouping = "midnight"
		Enums.LevelGrouping.SUNRISE : level_grouping = "sunrise"
	
	if time_best != null: level_data[level_grouping]["id" + str(id)]["time_best"] = time_best
	if par_best != null: level_data[level_grouping]["id" + str(id)]["par_best"] = par_best
	if jug_history != null: level_data[level_grouping]["id" + str(id)]["jug_history"] = jug_history
	if hardcore_history != null: level_data[level_grouping]["id" + str(id)]["hardcore_history"] = hardcore_history
		


func establish_settings_save():
	settings_data = {}
	save_settings()


#### file access functions
func save_records():
	#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.WRITE, enc_key)
	access = FileAccess.open(savepath + levels_file, FileAccess.WRITE)
	access.store_string(JSON.stringify(level_data))
	access.close()

func load_records():
	if FileAccess.file_exists(savepath + levels_file):
		#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.READ, enc_key)
		access = FileAccess.open(savepath + levels_file, FileAccess.READ)
		level_data = JSON.parse_string(access.get_as_text())
		access.close()

func save_completion():
	#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.WRITE, enc_key)
	access = FileAccess.open(savepath + completion_file, FileAccess.WRITE)
	access.store_string(JSON.stringify(completion_data))
	access.close()

func load_completion():
	if FileAccess.file_exists(savepath + completion_file):
		#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.READ, enc_key)
		access = FileAccess.open(savepath + completion_file, FileAccess.READ)
		completion_data = JSON.parse_string(access.get_as_text())
		access.close()

func save_settings():
	#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.WRITE, enc_key)
	access = FileAccess.open(savepath + settings_file, FileAccess.WRITE)
	access.store_string(JSON.stringify(settings_data))
	access.close()

func load_settings():
	if FileAccess.file_exists(savepath + settings_file):
		#access = FileAccess.open_encrypted_with_pass(savepath + levels_file, FileAccess.READ, enc_key)
		access = FileAccess.open(savepath + settings_file, FileAccess.READ)
		settings_data = JSON.parse_string(access.get_as_text())
		access.close()
		
func erase_progress():
	DirAccess.remove_absolute(savepath + levels_file)
	DirAccess.remove_absolute(savepath + completion_file)
	establish_level_save()
	establish_settings_save()
