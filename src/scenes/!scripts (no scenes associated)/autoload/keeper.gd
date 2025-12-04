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
	if !FileAccess.file_exists(savepath + completion_file):
		establish_completion_save()
	if !FileAccess.file_exists(savepath + settings_file):
		establish_settings_save()
	
#### establishments
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

func establish_completion_save():
	completion_data = {
		"debug":{},
		"daylight":{},
		"sunset":{},
		"midnight":{},
		"sunrise":{}
	}
	fresh_populate_section_completion("levels_debug")
	fresh_populate_section_completion("levels_tutorial")
	fresh_populate_section_completion("levels_easy")
	fresh_populate_section_completion("levels_medium")
	fresh_populate_section_completion("levels_hard")
	
	save_completion()

func establish_settings_save():
	settings_data = { # defaults established here
		"sensitivity" : 0.42,
		"fov" : 85,
		"crouch toggle" : false,
		"hidden labels" : false,
		"master vol" : 100,
		"sfx vol" : 100,
		"music vol" : 100,
		"ambient vol" : 100,
		"fullscreen" : true,
		"4by3" : false,
		"resolution scale" : 1
		
	}
	save_settings()

#### population
func fresh_populate_section(level_section):
	var current_section = get_section_name(level_section)

	var level_array = Gamestate.level_manager.get(level_section)
	for i in level_array.size():
		if !level_data[current_section].has("id" + str(i)):
			level_data[current_section]["id" + str(i)] = {"time_best" : null, "par_best" : null, "jug_history" : false, "hardcore_history" : false}

func fresh_populate_section_completion(level_section):
	var current_section = get_section_name(level_section)
	
	var level_array = Gamestate.level_manager.get(level_section)
	print(level_section)
	for i in level_array.size():
		print(i)
		if !completion_data[current_section].has("id" + str(i)):
			completion_data[current_section]["id" + str(i)] = {"level_complete" : false,  "time_complete" : false, "par_complete" : false, "jug_complete" : false, "hardcore_complete" : false}

#### write and retrieval
func get_level_history(grouping, id) -> Dictionary: 
	var level_grouping = _get_group_name(grouping)
		
	var level_info = {
		"time_best" : level_data[level_grouping]["id" + str(id)]["time_best"],
		"par_best" : level_data[level_grouping]["id" + str(id)]["par_best"],
		"jug_history" : level_data[level_grouping]["id" + str(id)]["jug_history"],
		"hardcore_history" :level_data[level_grouping]["id" + str(id)]["hardcore_history"]
	}
	return level_info

func write_level_history(grouping, id, time_best, par_best, jug_history, hardcore_history):
	var level_grouping = _get_group_name(grouping)
	
	if time_best != null: level_data[level_grouping]["id" + str(id)]["time_best"] = time_best
	if par_best != null: level_data[level_grouping]["id" + str(id)]["par_best"] = par_best
	if jug_history != null: level_data[level_grouping]["id" + str(id)]["jug_history"] = jug_history
	if hardcore_history != null: level_data[level_grouping]["id" + str(id)]["hardcore_history"] = hardcore_history
		

func get_level_completion(grouping, id) -> Dictionary: 
	var level_grouping = _get_group_name(grouping)
		
	var level_info = {
		"level_complete" : completion_data[level_grouping]["id" + str(id)]["level_complete"],
		"time_complete" : completion_data[level_grouping]["id" + str(id)]["time_complete"],
		"par_complete" : completion_data[level_grouping]["id" + str(id)]["par_complete"],
		"jug_complete" : completion_data[level_grouping]["id" + str(id)]["jug_complete"],
		"hardcore_complete" :completion_data[level_grouping]["id" + str(id)]["hardcore_complete"]
	}
	return level_info

func write_level_completion(grouping, id, level_complete, time_complete, par_complete, jug_complete, hardcore_complete):
	var level_grouping = _get_group_name(grouping)
	
	if level_complete != false: completion_data[level_grouping]["id" + str(id)]["level_complete"] = true
	if time_complete != false: completion_data[level_grouping]["id" + str(id)]["time_complete"] = true
	if par_complete != false: completion_data[level_grouping]["id" + str(id)]["par_complete"] = true
	if jug_complete != false: completion_data[level_grouping]["id" + str(id)]["jug_complete"] = true
	if hardcore_complete != false: completion_data[level_grouping]["id" + str(id)]["hardcore_complete"] = true

func write_settings_data(current_settings_data : Dictionary):
	settings_data = current_settings_data

func get_settings_data():
	return settings_data

#### helpers
func _get_group_name(grouping):
	var group_name = ""
	match grouping:
		Enums.LevelGrouping.DEBUG : group_name = "debug"
		Enums.LevelGrouping.DAYLIGHT : group_name = "daylight"
		Enums.LevelGrouping.SUNSET : group_name = "sunset"
		Enums.LevelGrouping.MIDNIGHT : group_name = "midnight"
		Enums.LevelGrouping.SUNRISE : group_name = "sunrise"
	
	return group_name

func get_section_name(section):
	var section_name = ""
	match section:
		"levels_debug" : section_name = "debug"
		"levels_tutorial" : section_name = "daylight"
		"levels_easy" : section_name = "sunset"
		"levels_medium" : section_name = "midnight"
		"levels_hard" : section_name = "sunrise"
	
	return section_name

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
	establish_completion_save()
	#establish_settings_save()
