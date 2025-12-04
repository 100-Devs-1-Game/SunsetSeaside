class_name LevelManager
extends Node

# there are better ways to do this,
# i can't be fucked

var path : NodePath
##### paths
const TITLE_BACKGROUND = {
	"name" : "title!!", 
	"path" : "res://scenes/levels/title_background.tscn"}
const TEST_LEVEL = {
	"name" : "test level",
	"path" : "res://scenes/levels/test_level.tscn"}
const DEBUG_LVL1 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}
const DEBUG_LVL2 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}
const DEBUG_LVL3 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}
const DEBUG_LVL4 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}
const DEBUG_LVL5 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}
const DEBUG_LVL6 = {
	"name" : "debug",
	"path" : "res://scenes/levels/debug_level.tscn"}

var levels_debug = [TITLE_BACKGROUND, TEST_LEVEL]
var levels_tutorial = [DEBUG_LVL1, DEBUG_LVL2]
var levels_easy = [DEBUG_LVL3, DEBUG_LVL4, DEBUG_LVL5]
var levels_medium = [DEBUG_LVL6]
var levels_hard = []

const grouping_ammo_amount = [1, 1, 1, 1, 1] # removed ability for 2 shots
# grouping order: debug, tutorial, easy, medium, hard

func fetch_level_name(grouping, id):
	return fetch_group_by_enum(grouping)[id]["name"]

func fetch_level_path(grouping, id):
	return fetch_group_by_enum(grouping)[id]["path"]

func fetch_group_by_enum(grouping):
	match grouping:
		Enums.LevelGrouping.DEBUG: return levels_debug
		Enums.LevelGrouping.DAYLIGHT: return levels_tutorial
		Enums.LevelGrouping.SUNSET: return levels_easy
		Enums.LevelGrouping.MIDNIGHT: return levels_medium
		Enums.LevelGrouping.SUNRISE: return levels_hard

func fetch_ammo_amount(grouping): # now entirely irrelevent
	match grouping:
		Enums.LevelGrouping.DEBUG: return grouping_ammo_amount[0]
		Enums.LevelGrouping.DAYLIGHT: return grouping_ammo_amount[1]
		Enums.LevelGrouping.SUNSET: return grouping_ammo_amount[2]
		Enums.LevelGrouping.MIDNIGHT: return grouping_ammo_amount[3]
		Enums.LevelGrouping.SUNRISE: return grouping_ammo_amount[4]

# these don't iterate until the actual previous or next, but mate, its fucking good enough mate
func fetch_next_level_info(grouping, id): # returns dictionary of info about the next level
	var level_info = {
		"grouping" = null,
		"id" = null, 
		"in next group" = false # so the gamestate to determine whether or not to return to level select
	}
	
	var next_group_enum
	match grouping:
		Enums.LevelGrouping.DEBUG: next_group_enum = Enums.LevelGrouping.DAYLIGHT
		Enums.LevelGrouping.DAYLIGHT: next_group_enum = Enums.LevelGrouping.SUNSET
		Enums.LevelGrouping.SUNSET: next_group_enum = Enums.LevelGrouping.MIDNIGHT
		Enums.LevelGrouping.MIDNIGHT: next_group_enum = Enums.LevelGrouping.SUNRISE
		Enums.LevelGrouping.SUNRISE: next_group_enum = null
	
	var check_group = fetch_group_by_enum(grouping)
	var next_group = null
	if next_group_enum != null:
		next_group = fetch_group_by_enum(next_group_enum) 
	
	var next_id = id + 1
	if next_id <= check_group.size() - 1:
		level_info["grouping"] = grouping
		level_info["id"] = next_id
	elif next_group != null:
		if next_group.size() > 0:
			level_info["grouping"] = next_group_enum
			level_info["id"] = 0
			level_info["in next group"] = true
	
	return level_info

func fetch_previous_level_info(grouping, id):
	var level_info = {
		"grouping" = null,
		"id" = null
	}
	
	var previous_grouping_enum
	match grouping:
		Enums.LevelGrouping.DEBUG: previous_grouping_enum = null
		Enums.LevelGrouping.DAYLIGHT: previous_grouping_enum = Enums.LevelGrouping.DEBUG
		Enums.LevelGrouping.SUNSET: previous_grouping_enum = Enums.LevelGrouping.DAYLIGHT
		Enums.LevelGrouping.MIDNIGHT: previous_grouping_enum = Enums.LevelGrouping.SUNSET
		Enums.LevelGrouping.SUNRISE: previous_grouping_enum = Enums.LevelGrouping.MIDNIGHT
		
	var previous_group = null
	if previous_grouping_enum != null:
		previous_group = fetch_group_by_enum(previous_grouping_enum)  
	
	if id == 0:
		level_info["grouping"] = previous_grouping_enum
		if previous_group != null:
			if previous_group.size() > 0:
				level_info["id"] = previous_group.size() - 1
	else:
		level_info["grouping"] = grouping
		level_info["id"] = id - 1
		
	return level_info
